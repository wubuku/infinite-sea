
$startLocation = Get-Location; 

$now = Get-Date
$formattedNow = $now.ToString('yyyyMMddHHmmss')
$logFile = "$startLocation\crafting_$formattedNow.log"


$dataFile = ".\data.json"
if (-not (Test-Path -Path $dataFile -PathType Leaf)) {
    "文件 $dataFile 不存在 " | Write-Host  -ForegroundColor Red
    return
}
$ComeFromFile = Get-Content -Raw -Path $dataFile
$dataInfo = $ComeFromFile | ConvertFrom-Json



$itemDataFile = "$startLocation\item.json"
if (-not (Test-Path -Path $itemDataFile -PathType Leaf)) {
    "文件 $itemDataFile 不存在 " | Write-Host  -ForegroundColor Red
    Set-Location $startLocation
    return
}
$itemData | ConvertTo-Json | Set-Content -Path $itemDataFile 


$playerRostersFile = ".\rosters.json"
if (-not (Test-Path -Path $playerRostersFile -PathType Leaf)) {
    "Player的船队信息文件 $playerRostersFile 不存在 " | Write-Host  -ForegroundColor Red
    return
}
$playerRostersJson = Get-Content -Raw -Path $playerRostersFile
$rosters = $playerRostersJson | ConvertFrom-Json



#可修改的参数
#是不是需要造船，造船之后将船Id放入 $shipIds 数组，否则后面需要转移船只时，需要手工来填充 $shipIds 数组
$craft = $true
#造船数量
#$cratingCount = 1
$cratingCount = 4
#造船完成后加入的默认船队（目前只能为$rosters.0）
$rosterId0 = $rosters.0
#造船所消耗的时间 这个时间应该大于等于Item Production中的时间
$craftingTime = 3

$shipIds = @()

if ($craft -and $cratingCount -ge 1) {
    "`n准备造 $cratingCount 艘船..." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor White
    for ($i = 1; $i -le $cratingCount; $i++) {
        "`n开始建造第 $i 艘..." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow      
        $random = New-Object System.Random  
        do {
            $num1 = $random.Next(1, 7)
            $num2 = $random.Next(1, 7)
            $num3 = $random.Next(1, 7)
        } while (($num1 + $num2 + $num3) -ne 6)
        $randomNums = @($num1, $num2, $num3)  
        $crafingResourceIds = @()
        $crafingResourceQuantities = @()
        "使用以下原材料：" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow  
        for ($j = 0; $j -lt $itemData.CraftingResources.Count; $j++) {
            "      $($itemData.CraftingResources[$j].Name) (Id:$($itemData.CraftingResources[$j].ItemId))->数量 $($itemData.CraftingResources[$j].Quantity+$randomNums[$j])"  | Tee-Object -FilePath $logFile -Append  |  Write-Host 
            $crafingResourceIds += $($itemData.CraftingResources[$j].ItemId)
            $crafingResourceQuantities += ($itemData.CraftingResources[$j].Quantity + $randomNums[$j])
        }
        $crafingResourceIds_ = "[" + ($crafingResourceIds -join ",") + "]"
        $crafingResourceQuantities_ = "[" + ($crafingResourceQuantities -join ",") + "]"
        try {
            $result = sui client call --package $dataInfo.main.PackageId --module skill_process_service --function start_ship_production --args  $dataInfo.main.SkillProcessCrafting  $crafingResourceIds_ $crafingResourceQuantities_  $dataInfo.main.Player  $dataInfo.common.ItemProducitonCrafting $clock  $dataInfo.coin.EnergyId --gas-budget 42000000 --json
            if (-not ('System.Object[]' -eq $result.GetType())) {
                "建造第 $i 艘船时返回信息: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
                Set-Location $startLocation
                return
            }
            $resultObj = $result | ConvertFrom-Json 
            "第 $i 艘船建造开始..." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
        }
        catch {
            "第 $i 艘船建造失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
            "提醒:很多时候都是因为Player造船原材料不够,建议先检查一下Player手头上的原材料数量,`n sui client object $($dataInfo.main.Player) --json " | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Blue
            Set-Location $startLocation 
            return    
        }

        "`n第 $i 艘船建造中...需要等待$craftingTime 秒钟..." | Write-Host
        Start-Sleep -Seconds ($craftingTime + 1)
        "第 $i 艘船该收工了...· " | Write-Host        

        "`n现在结束第 $i 艘船的建造..." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
        try {
            $commandCompleteShipProduction = "sui client call --package $($dataInfo.main.PackageId) --module skill_process_aggregate --function complete_ship_production --args  $($dataInfo.main.SkillProcessCrafting)  $rosterId0 $($dataInfo.main.Player)  $($dataInfo.common.ItemProducitonCrafting) $($dataInfo.common.ExperienceTable) $clock  --gas-budget 42000000 --json"
            #$commandCompleteShipProduction | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
            $result = Invoke-Expression -Command $commandCompleteShipProduction
            if (-not ('System.Object[]' -eq $result.GetType())) {
                "结束第 $i 艘船建造返回信息: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
                Set-Location $startLocation
                return
            }
            $resultObj = $result | ConvertFrom-Json     
            foreach ($object in $resultObj.objectChanges) {
                if ($object.objectType -like "*::ship::Ship") {
                    $shipId = $object.objectId
                    $shipIds += $shipId
                    "第 $i 艘船建造完毕， ShipId: $shipId`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
                    break;   
                }
            }     
        }
        catch {
            "第 $i 艘船建造失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
            Set-Location $startLocation 
            return    
        }
    }
}


#造船完毕后是否编入新的船队
$transferShip = $true
#源头船队，默认为0
$sourceRoster = $rosters.0
#目标船队(可设置的目标1,2,3,4)
$targetRoster = $rosters.4
# 如果是指定船只的话，请录入 $shipIds 数组
#$shipIds += "0xc9600a59425ff3cfae1464d87d32e750a6c2d572492bc18eb4094c65e5ac9d74"
#每个船队最多船只数量
$RosterShipMaxCount = 4

if ($transferShip -and $shipIds.Length -gt 0) { 
    #目标船队当前船只数量
    $targetRosterCurrentShipCount = 0 
    #查询一下目标船队的信息  
    "转移船只到目标船队 $targetRoster ..." | Tee-Object -FilePath $logFile -Append  |  Write-Host  -ForegroundColor Yellow
    $getRosterResult = ""
    try {
        $getRosterResult = sui client object $targetRoster --json 
        if (-not ('System.Object[]' -eq $getRosterResult.GetType())) {
            "获取Roster $targetRoster 信息时返回 $getRosterResult" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Red
            Set-Location $startLocation
            return
        }
        $getRosterResultJson = $getRosterResult | ConvertFrom-Json
        "目标船队编号： $($getRosterResultJson.content.fields.roster_id.fields.sequence_number) " | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
        $targetRosterCurrentShipCount = $getRosterResultJson.content.fields.ships.fields.size
        "目前拥有船只数量：$targetRosterCurrentShipCount,最多再加入 $($RosterShipMaxCount-$targetRosterCurrentShipCount) 只。" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
    }
    catch {
        "获取Roster $targetRoster 信息失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
        "返回的结果为:$getRosterResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
        Set-Location $startLocation
        return    
    }       
    $tranferResult = ""
    $index = 0
    foreach ($shipId in $shipIds) {
        if ($index -lt ($RosterShipMaxCount - $targetRosterCurrentShipCount) ) {
            #if ($true) {
            "`现在将船只 $shipId 加入目标船队。" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow  
            try {
                $tranferResult =
                sui client call --package $dataInfo.main.PackageId --module roster_aggregate --function transfer_ship --args  $sourceRoster $dataInfo.main.Player $shipId  $targetRoster  [0] --gas-budget 42000000 --json
                if (-not ('System.Object[]' -eq $tranferResult.GetType())) {
                    "转移船只 $shipId 时返回信息： $tranferResult" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Red
                    Set-Location $startLocation
                    return
                }
                $tranferResultJson = $tranferResult | ConvertFrom-Json
                "转移成功。" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Green
            }
            catch {
                "转移船只失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
                "返回的结果为:$tranferResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
                Set-Location $startLocation
                return    
            }
            $index++
        }
    }
    "本次加入目标船队船只数量: $index" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    "可以使用以下命令查看目标船队当前信息: sui client object $targetRoster --json " | Tee-Object -FilePath $logFile -Append  |  Write-Host  -ForegroundColor Blue
}

"该脚本执行后相关的日志请参考: $logFile" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Blue

Set-Location $startLocation 


