$startLocation = Get-Location; 

$now = Get-Date
$formattedNow = $now.ToString('yyyyMMddHHmmss')
$logFile = "$startLocation\environment_roster_rebirth_$formattedNow.log"

$server = "http://47.96.81.197"
$port = 8809
$mapId = "0x27ef041f823083360bdf7c8de900977b49859970373bb2d453b6deaad0604b96"

$serverUrl = $server + ":" + $port;

$getAllIslandResult = $null
try {
    $getAllIslandUrl = $serverUrl + "/api/Maps/$mapId/MapLocations"
    $command = "curl -X GET $getAllIslandUrl -H `"accept: application/json`""
    #$getAllIslandResult = curl -X GET $getAllIslandUrl -H "accept: application/json"   
    $command | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
    $getAllIslandResult = Invoke-Expression -Command $command 
    # $getAllIslandResult.GetType() | Write-Host 
    # if (-not ('System.Object[]' -eq $getAllIslandResult.GetType())) {
    #     "获取岛屿列表时返回 $getAllIslandResult" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Red
    #     return
    # }
    $getAllIslandResultObj = $getAllIslandResult | ConvertFrom-Json
    "一共有 $($getAllIslandResultObj.Count) 个岛屿..." | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    
    foreach ($island in $getAllIslandResultObj) {
        "coordinates:($($island.coordinates.x),$($island.coordinates.y))" |  Write-Host 
    }
}
catch {
    "获取岛屿列表失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
    "返回的结果为:$getAllIslandResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    return    
}