$startLocation = Get-Location; 

$now = Get-Date
$formattedNow = $now.ToString('yyyyMMddHHmmss')
$logFile = "$startLocation\RequestEnergy.log"

$dataFile = "$startLocation\data.json"
if (-not (Test-Path -Path $dataFile -PathType Leaf)) {
    "文件 $dataFile 不存在 " | Write-Host  -ForegroundColor Red
    return
}
$ComeFromFile = Get-Content -Raw -Path $dataFile
$dataInfo = $ComeFromFile | ConvertFrom-Json


#一亿
$itioku = 100000000

$accountAddress = sui client active-address 
"当前账户地址： $accountAddress" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow

$balanceResult = ""
"请求之前,看一下当前账户的 Energy 余额：" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow
$requestBeforeAmount = 0
$coinType = $dataInfo.coin.PackageId + "::energy::ENERGY"
$commandRequestBalance = 'curl -X POST -H "Content-Type: application/json" -d ''{"jsonrpc":"2.0","id":1,"method":"suix_getCoins","params":["' + $accountAddress + '","' + $coinType + '"]}'' https://fullnode.testnet.sui.io/'
$commandRequestBalance | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
try {
    $balanceResult = Invoke-Expression -Command $commandRequestBalance
    $balanceInfoObj = $balanceResult | ConvertFrom-Json
    foreach ($object in $balanceInfoObj.result.data) {
        "Coin Object Id: $($object.coinObjectId),数量:$($object.balance/$itioku)" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White
        $requestBeforeAmount = $requestBeforeAmount + $object.balance / $itioku
    }
}
catch {
    "查询账户余额失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
    "返回的结果为:$($balanceResult/$itioku)" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation
    return    
}
"当前 Energy 余额，总计：$requestBeforeAmount" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow

return

$requestResult = ""
$requestAmount = 100000000000
try {
    "`n申请 $($requestAmount/$itioku) Energy ......" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
    $commandRequest = "sui client call --package  $($dataInfo.coin.PackageId) --module energy_faucet --function request_a_drop --args $($dataInfo.coin.FaucetId) --json" 
    $commandRequest | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
    $requestResult = Invoke-Expression -Command $commandRequest
    if (-not ('System.Object[]' -eq $requestResult.GetType())) {
        "申请 Energy 时返回信息： $requestResult" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $requestResultObj = $requestResult | ConvertFrom-Json
    foreach ($object in $requestResultObj.balanceChanges) {
        if ($object.coinType -eq $coinType && $object.amount -eq $requestAmount) {
            "申请成功。" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
            break
        }
    }
}
catch {
    "申请 Energy 失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
    "返回的结果为:$requestResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation
    return    
}    
$requestAferAmount = 0
"`n申请完成之后，再看一下当前账户的 Energy 余额：" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow 
$commandRequestBalance | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
try {
    $balanceResult = Invoke-Expression -Command $commandRequestBalance
    $balanceInfoObj = $balanceResult | ConvertFrom-Json
    foreach ($object in $balanceInfoObj.result.data) {
        "Coin Object Id: $($object.coinObjectId),数量:$($object.balance/$itioku)" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White
        $requestAferAmount = $requestAferAmount + $object.balance / $itioku
    }
}
catch {
    "查询账户余额失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
    "返回的结果为:$($balanceResult/$itioku)" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation
    return    
}

"当前 Energy 余额，总计：$requestAferAmount" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow
"申请之前： $requestBeforeAmount ，申请数量： $($requestAmount/$itioku)， 申请之后： $requestAferAmount " |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow -NoNewline

if ($requestBeforeAmount + $($requestAmount / $itioku) -eq $requestAferAmount) {
    "($requestBeforeAmount" + "+" + $($requestAmount / $itioku) + "=" + "$requestAferAmount)，OK" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Green
}
else {
    "($requestBeforeAmount" + "+" + $($requestAmount / $itioku) + "=" + "$requestAferAmount)，NO" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Green
}

Set-Location $startLocation

