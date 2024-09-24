
$startLocation = Get-Location; 

$now = Get-Date


$dataFile = ".\data.json"
if (-not (Test-Path -Path $dataFile -PathType Leaf)) {
    "文件 $dataFile 不存在 " | Write-Host  -ForegroundColor Red
    return
}
$ComeFromFile = Get-Content -Raw -Path $dataFile
$dataInfo = $ComeFromFile | ConvertFrom-Json


$rosterId = "0xb97a70c0c4d38cf2ae3f16ca4d80edd2d0540b60bc05610b4975c8480f28e915"


$formattedNow = $now.ToString('yyyyMMddHHmmss')
$logFile = "$startLocation\roster_$rosterId.log"
"Roster Id: $rosterId" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Green

$getRosterResult = ""
$shipIds = @()
try {
    $getRosterResult = sui client object $rosterId --json 
    if (-not ('System.Object[]' -eq $getRosterResult.GetType())) {
        "获取Roster $rosterId 信息时返回 $getRosterResult" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $getRosterResultObj = $getRosterResult | ConvertFrom-Json
    "船队编号： $($getRosterResultObj.content.fields.roster_id.fields.sequence_number) " | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
    $rosterCurrentShipCount = $getRosterResultObj.content.fields.ships.fields.size
    "目前拥有船只数量：$rosterCurrentShipCount 只。" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
    $shipIds = $getRosterResultObj.content.fields.ship_ids
    if ($shipIds.Count -gt 0) {
        "分别为：" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Gray
        foreach ($shipId in $shipIds) {
            "   $shipId" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor White
        }
    }
    "所属Player: $($getRosterResultObj.content.fields.roster_id.fields.player_id)" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
    "当前位置： $($getRosterResultObj.content.fields.updated_coordinates.fields)" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor White
    $targetCoordinates = $getRosterResultObj.content.fields.target_coordinates
    if ($null -ne $targetCoordinates) {
        "目的地： $($targetCoordinates.fields)" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor White
    }
    else { Write-Host "     没有设置目的地" }
    $status = $getRosterResultObj.content.fields.status
    $speed = $getRosterResultObj.content.fields.speed
    "船队速度: $speed " | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor White
    "船队状态值(status): $status ，表示：" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor White
    if ($status -eq 0) {
        "   停泊中(at_anchor)" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
    }
    elseif ($status -eq 1) {
        "    行进中(underway)" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
    }
    elseif ($status -eq 2) {
        "    战斗中(in_battle)" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
    }
    elseif ($status -eq 3) {
        "    已损毁(destroyed)" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
    }
    else {
        "    不明(unvalid)" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
    }
}
catch {
    "获取Roster $rosterId 信息失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
    "返回的结果为:$getRosterResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation
    return    
}  


foreach ($shipId in $shipIds) {
    "`船只 $shipId 相关信息如下：" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow  
    try {
        $shipResult = sui client object $shipId --json 
        if (-not ('System.Object[]' -eq $shipResult.GetType())) {
            "船只 $shipId 时返回信息： $shipResult" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Red
            Set-Location $startLocation
            return
        }
        $shipObj = $shipResult | ConvertFrom-Json
        "健康点(health_points): $($shipObj.content.fields.health_points)" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Green
        "攻击(attack): $($shipObj.content.fields.attack)" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Green
        "防御值(protection): $($shipObj.content.fields.protection)" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Green
        "速度(speed): $($shipObj.content.fields.speed)" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Green
        $items = $shipObj.content.fields.building_expenses.fields.items
        if ($null -ne $items -and $items.Length -gt 0) {
            "此船由以下资源建造而来：" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
            foreach ($item in $items) {
                "   Item Id: $($item.fields.item_id) -> quantity: $($item.fields.quantity)" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Green
            }
        }
        $inventory = $shipObj.content.fields.inventory
        if ($null -ne $inventory -and $inventory.Length -gt 0) {
            "此船装载以下物资：" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
            foreach ($resouce in $inventory) {
                "   Item Id: $($resouce.fields.item_id) -> quantity: $($resouce.fields.quantity)" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Green
            }
        }
        else {
            "没有装载任何物资。" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
        }

    }
    catch {
        "查询船只 $shipId 信息失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
        "返回的结果为:$shipResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
        Set-Location $startLocation
        return    
    }
}


Set-Location $startLocation