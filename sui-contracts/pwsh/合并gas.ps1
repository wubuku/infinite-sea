
$address = sui client active-address
"当前账户地址: $address" | Write-Host  -ForegroundColor Cyan

$result = $null;
try {
    $result = sui client gas --json 
    if (-not ('System.Object[]' -eq $result.GetType())) {
        "查询 gas 时返回: $result" | Write-Host  -ForegroundColor Red
        return
    }
    $response = $result | ConvertFrom-Json
    if ($response.Count -lt 2) {
        "只有 $($response.Count) 条记录，不需要合并" | Write-Host  -ForegroundColor Blue
        return
    }
    $mainGasCoinId = $response[0].gasCoinId;
    $amount = [decimal]$response[0].suiBalance;
    "将 $mainGasCoinId 作为首选条目，目前余额： $amount " | Write-Host  -ForegroundColor Yellow
    for ($i = 1; $i -lt $response.Count; $i++) {
        "$i -> GasCoinId: $($response[$i].gasCoinId) , suiBalance:$($response[$i].suiBalance)" | Write-Host  -ForegroundColor Green
        $mergeResult = $null
        try {
            $commandRequest = "sui client merge-coin --primary-coin $mainGasCoinId --coin-to-merge $($response[$i].gasCoinId) --json" 
            $commandRequest | Write-Host  -ForegroundColor Blue
            $mergeResult = Invoke-Expression -Command $commandRequest
            #$mergeResult = sui client merge-coin --primary-coin $mainGasCoinId --coin-to-merge $($response[$i].gasCoinId) --json
            if (-not ('System.Object[]' -eq $mergeResult.GetType())) {
                "合并 gas 时返回: $mergeResult" | Write-Host  -ForegroundColor Red
                continue
            }
            $amount = $amount + [decimal]$response[$i].suiBalance
            "合并成功，主条目余额现在应该大于等于：$amount" | Write-Host  -ForegroundColor Yellow
        }
        catch {
            "合并 gas 信息失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
            "返回的结果为:$mergeResult"  |  Write-Host 
            continue
        }
    }
    "合并完成" |  Write-Host -ForegroundColor Green
}
catch {
    "查询 gas 信息失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
    "返回的结果为:$result"   |  Write-Host 
    return    
}
# if ($null -eq $result) {    
#     "没能获取目标船队当前坐标，请先检查一下。" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
# }