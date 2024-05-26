$startLocation = Get-Location; 

$now = Get-Date
$formattedNow = $now.ToString('yyyyMMddHHmmss')
$logFile = "$startLocation\set_sail_$formattedNow.log"

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


#用那个船队去挑战？3表示船队编号
$roster = $rosters.4
$energy_amount = 500

#先查看一下目标船队的坐标
#$targetCoordinates = $null
$targetCoordinates = [PSCustomObject]@{
    x = 500
    y = 500
}
$environmentRosterResult = ""
if ($null -eq $targetCoordinates) {
    $environmentRosterJsonFile = "$startLocation\environment_roster.json"
    if (-not (Test-Path -Path $environmentRosterJsonFile -PathType Leaf)) {
        "环境船队信息文件 $playerRostersFile 不存在 " | Write-Host  -ForegroundColor Red
        return
    }
    $environmentRosterJson = Get-Content -Raw -Path $environmentRosterJsonFile
    $environmentRoster = $environmentRosterJson | ConvertFrom-Json
    try {
        $environmentRosterResult = sui client object $environmentRoster.RosterId --json 
        if (-not ('System.Object[]' -eq $environmentRosterResult.GetType())) {
            "获取目标船队 $($environmentRoster.RosterId) 信息时返回: $environmentRosterResult" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            Set-Location $startLocation
            return
        }
        $environmentRosterObj = $environmentRosterResult | ConvertFrom-Json
        $targetCoordinates = $environmentRosterObj.content.fields.updated_coordinates.fields
        "`n将要攻击的目标船队当前坐标：($($targetCoordinates.x),$($targetCoordinates.y))" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
    }
    catch {
        "获取目标船队 $($environmentRoster.RosterId) 信息失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
        "返回的结果为:$environmentRosterResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
        Set-Location $startLocation
        return    
    }
    if ($null -eq $environmentRosterResult) {    
        "没能获取目标船队当前坐标，请先检查一下。" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
    }
}

try {
    "`n准备出发，目标坐标：($($targetCoordinates.x),$($targetCoordinates.y))。" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
    $command = "sui client call --package $($dataInfo.main.PackageId)  --module roster_service --function set_sail --args $roster $($dataInfo.main.Player) $($targetCoordinates.x) $($targetCoordinates.y) '0x6' $($dataInfo.coin.EnergyId) $energy_amount --gas-budget 11000000 --json" 
    $command | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
    $setSailResult = Invoke-Expression -Command $command
    if (-not ('System.Object[]' -eq $setSailResult.GetType())) {
        "船队启航返回信息： $setSailResult" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $setSailResultObj = $setSailResult | ConvertFrom-Json
    "船队已经启航，等到达目的地，将发生战斗。`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
}
catch {
    "船队启航失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
    "返回的结果为:$setSailResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation
    return    
}

Set-Location $startLocation

