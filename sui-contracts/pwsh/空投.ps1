


$dataFile = ".\data.json"
if (-not (Test-Path -Path $dataFile -PathType Leaf)) {
    "文件 $dataFile 不存在 " | Write-Host  -ForegroundColor Red
    return
}
$ComeFromFile = Get-Content -Raw -Path $dataFile
$dataInfo = $ComeFromFile | ConvertFrom-Json

$startLocation = Get-Location; 
$itemDataFile = "$startLocation\item.json"
if (-not (Test-Path -Path $itemDataFile -PathType Leaf)) {
    "文件 $itemDataFile 不存在 " | Write-Host  -ForegroundColor Red
    Set-Location $startLocation
    return
}
$itemDataJson = Get-Content -Raw -Path $itemDataFile
$itemData = $itemDataJson | ConvertFrom-Json


$logFile = "$startLocation\airdrop_$($dataInfo.main.Player).log"


#$item = $itemData.ResourceTypeWoodcutting
$item = $itemData.ResourceTypeMining
#$item = $itemData.ItemCottonSeeds
$quantity = 350

#$playerId = $dataInfo.main.Player
$playerId = "0x48f335164aec06ea129253b9e197be12aada47f17ef367f270badad09399d42f"

"`n给 Player 空投 $quantity 个 $($item.Name) (Id=$($item.ItemId))种子..." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
$result = ""
try {
    $commandRequest = "sui client call --package $($dataInfo.main.PackageId)  --module player_aggregate --function airdrop --args $playerId $($dataInfo.main.Publisher) $($item.ItemId) $quantity --gas-budget 11000000 --json"
    $commandRequest | Write-Host  -ForegroundColor Blue
    $result = Invoke-Expression -Command $commandRequest
    if (-not ('System.Object[]' -eq $result.GetType())) {
        "空投时返回信息 $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $resultObj = $result | ConvertFrom-Json
    "空投成功" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
}
catch {
    "空投失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
    "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation 
    return    
}
Set-Location $startLocation 