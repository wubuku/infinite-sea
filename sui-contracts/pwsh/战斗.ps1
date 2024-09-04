$startLocation = Get-Location; 

$now = Get-Date
$formattedNow = $now.ToString('yyyyMMddHHmmss')
$logFile = "$startLocation\battle_$formattedNow.log"

$dataFile = "$startLocation\data.json"
if (-not (Test-Path -Path $dataFile -PathType Leaf)) {
    "文件 $dataFile 不存在 " | Write-Host  -ForegroundColor Red
    return
}
$ComeFromFile = Get-Content -Raw -Path $dataFile
$dataInfo = $ComeFromFile | ConvertFrom-Json

$playerRostersFile = "$startLocation\rosters.json"
if (-not (Test-Path -Path $playerRostersFile -PathType Leaf)) {
    "Player的船队信息文件 $playerRostersFile 不存在 " | Write-Host  -ForegroundColor Red
    return
}

$playerRostersJson = Get-Content -Raw -Path $playerRostersFile
$rosters = $playerRostersJson | ConvertFrom-Json

#被攻击方船队Id，要么直接指定，要么来自 environment_roster.json 
$targetRosterId = "0xc858c3711f76652b7c6ee2342c06f35fb20c3578991f9d0ac9e382e846bab599"

if ($null -eq $targetRosterId -or $targetRosterId -eq "") {
    $environmentRosterJsonFile = "$startLocation\environment_roster.json"
    if (-not (Test-Path -Path $environmentRosterJsonFile -PathType Leaf)) {
        "环境船队信息文件 $playerRostersFile 不存在 " | Write-Host  -ForegroundColor Red
        return
    }
    $environmentRosterJson = Get-Content -Raw -Path $environmentRosterJsonFile
    $environmentRoster = $environmentRosterJson | ConvertFrom-Json
    $targetRosterId = $environmentRoster.RosterId
}

$targetCoordinates = $null
$targetRosterPlayer = $null
try {
    $environmentRosterResult = sui client object $targetRosterId --json 
    if (-not ('System.Object[]' -eq $environmentRosterResult.GetType())) {
        "获取目标船队 $targetRosterId 信息时返回: $environmentRosterResult" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        return
    }
    $environmentRosterObj = $environmentRosterResult | ConvertFrom-Json
    $targetCoordinates = $environmentRosterObj.content.fields.updated_coordinates.fields
    $targetRosterPlayer = $environmentRosterObj.content.fields.roster_id.fields.player_id
    "`n将要攻击的目标船队当前坐标：($($targetCoordinates.x),$($targetCoordinates.y))" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
}
catch {
    "获取目标船队 $targetRosterId 信息失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
    "返回的结果为:$environmentRosterResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    return    
}
if ($null -eq $targetCoordinates) {    
    "没能获取目标船队当前坐标，请先检查一下。" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
    return;
}

#发起战斗的船队？3表示编号
$roster = $rosters.2

#是不是只查看战斗的结果，如果是那么不需要交战，只需要给到一个$shipBattleId
$onlyCheckShipBattleResult = $false
$shipBattleId = $null
#$shipBattleId = "0x81bbcfd91d256076af4e633ec704eb009fc0524187368682fc936f80cbb6f050"

$initiator_coordinates_x = $targetCoordinates.x
$initiator_coordinates_y = $targetCoordinates.y
$responder_coordinates_x = 0
$responder_coordinates_y = 0


$result = ""
if (-not $onlyCheckShipBattleResult) {
    try {
        "`n开始交战..." | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
        $command = "sui client call --package $($dataInfo.main.PackageId)  --module ship_battle_service --function initiate_battle_and_auto_play_till_end --args $($dataInfo.main.Player) $roster  $targetRosterId '0x6' $initiator_coordinates_x $initiator_coordinates_y $responder_coordinates_x $responder_coordinates_y --gas-budget 4999000000 --json"
        $command | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
        $result = Invoke-Expression -Command $command
        if (-not ('System.Object[]' -eq $result.GetType())) {
            "交战时返回信息： $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            Set-Location $startLocation
            return
        }
        $setSailResultObj = $result | ConvertFrom-Json   
        foreach ($object in $setSailResultObj.objectChanges) {
            if ($object.objectType -like "*::ship_battle::ShipBattle") {
                $shipBattleId = $object.objectId
                "ShipBattle: $shipBattleId`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
                break;   
            }
        }
        "Digest: $($setSailResultObj.digest)" |  Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor White
        "消耗gas如下:" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
        $setSailResultObj.effects.gasUsed | ConvertTo-Json | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
        #$setSailResultObj | ConvertTo-Json |  Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor White
        "交战结束。`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green    
    }
    catch {
        "交战失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
        "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
        Set-Location $startLocation
        return    
    }
}
if ($null -eq $shipBattleId -or $shipBattleId -eq "") {    
    "ShipBattleId 无值，请检查问题所在。" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
    Set-Location $startLocation
    return
}
$shipBattleResult = ""
$initiator = ""
$responder = ""
$round_number = $null, $status = $null, $winner = $null
try {
    $shipBattleResult = sui client object $shipBattleId --json 
    if (-not ('System.Object[]' -eq $shipBattleResult.GetType())) {
        "获取战斗信息时返回: $shipBattleResult" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $shipBattle = $shipBattleResult | ConvertFrom-Json
    $initiator = $shipBattle.content.fields.initiator
    "发起方: $initiator" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow
    $responder = $shipBattle.content.fields.responder
    "应战方: $responder" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow
    $round_number = $shipBattle.content.fields.round_number
    "回合数: $round_number" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow
    $status = $shipBattle.content.fields.status
    "状态值: $status,表示：" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow
    if ($null -ne $status) {
        if (0 -eq $status) {
            "   进行中..." | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow
        }
        elseif ($status -ge 1) {
            "   已结束。" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow 
            if ($status -eq 2) {
                "   已搜刮。" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow 
            }
        }
        else {
            "   无法识别。" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red 
        }
    }
    else {
        "   空值" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red 
    }
    $winner = $shipBattle.content.fields.winner
    "`nWinner值为 $winner , 胜利的一方为：" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow
    if ($null -ne $winner) {
        if (1 -eq $winner) {
            "   发起方。" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow 
        }
        elseif (0 -eq $winner) {
            "   应战方。" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow 
        }
        else {
            "   无法判断谁赢了。" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red 
        }
    }
    else {
        "   不知道谁赢了" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red 
    }
}
catch {
    "获取战斗信息失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
    "返回的结果为:$shipBattleResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation
    return    
}

#战斗结束，赢得一方收拾战利品
if ($status -eq 1) {  
    $player = ""
    $loser_player = ""
    if ($winner -eq 1) {
        $player = $dataInfo.main.Player
        $loser_player = $targetRosterPlayer
    }
    else {
        $player = $targetRosterPlayer
        $loser_player = $dataInfo.main.Player
    }
    $takeLootResult = "" 
    try {
        "`n开始收拾战利品..." | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
        $command = "sui client call --package $($dataInfo.main.PackageId)  --module ship_battle_aggregate --function take_loot --args $shipBattleId $player $loser_player $initiator $responder  $($dataInfo.common.ExperienceTable)  '0x6'  0  --gas-budget 4999000000 --json"
        $command | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
        $takeLootResult = Invoke-Expression -Command $command
        if (-not ('System.Object[]' -eq $takeLootResult.GetType())) {
            "交战时返回信息： $takeLootResult" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            Set-Location $startLocation
            return
        }
        $takeLootObj = $takeLootResult | ConvertFrom-Json   
        "Digest: $($takeLootObj.digest)" |  Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor White
        # foreach ($object in $takeLootObj.objectChanges) {
        #     if ($object.objectType -like "*::ship_battle::ShipBattle") {
        #         $shipBattleId = $object.objectId
        #         "ShipBattle: $shipBattleId`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
        #         break;   
        #     }
        # }  
        #$takeLootObj | ConvertTo-Json |  Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor White
        "搜刮完毕。`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green    
    }
    catch {
        "搜刮失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
        "返回的结果为:$takeLootResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
        Set-Location $startLocation
        return    
    }
}

"运行该脚本日志请参考:$logFile" |  Write-Host 

Set-Location $startLocation