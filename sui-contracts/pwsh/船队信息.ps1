
$startLocation = Get-Location; 

$now = Get-Date


$dataFile = ".\data.json"
if (-not (Test-Path -Path $dataFile -PathType Leaf)) {
    "文件 $dataFile 不存在 " | Write-Host  -ForegroundColor Red
    return
}
$ComeFromFile = Get-Content -Raw -Path $dataFile
$dataInfo = $ComeFromFile | ConvertFrom-Json


$rosterId = "0x6b98f5244f713a50fa4038e05d253922dfcbcb1bce06208a7a0d50333fe34db2"


$formattedNow = $now.ToString('yyyyMMddHHmmss')
$logFile = "$startLocation\roster_$rosterId.log"

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
    "目标船队编号： $($getRosterResultObj.content.fields.roster_id.fields.sequence_number) " | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
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