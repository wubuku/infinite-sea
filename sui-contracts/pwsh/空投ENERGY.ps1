$startLocation = $PSScriptRoot

$dataFile = "$startLocation\data.json"
if (-not (Test-Path -Path $dataFile -PathType Leaf)) {
    "文件 $dataFile 不存在 " | Write-Host  -ForegroundColor Red
    return
}
$ComeFromFile = Get-Content -Raw -Path $dataFile
$dataInfo = $ComeFromFile | ConvertFrom-Json


$energyTokenFile = "$startLocation\airdrop_energy_token\Leaderboard_Snapshot_for_EnergyToken.txt"
if (-not (Test-Path -Path $energyTokenFile -PathType Leaf)) {
    "文件 $energyTokenFile 不存在 " | Write-Host  -ForegroundColor Red
    return
}
$energyTokenContent = Get-Content -Raw -Path $energyTokenFile
$energyTokenInfo = $energyTokenContent | ConvertFrom-Json



$now = Get-Date
$formattedNow = $now.ToString('yyyyMMddHHmmss')
$logFile = "$startLocation\airdrop_energy_token\$formattedNow.log"


$eneryId = "0x1963317567a63f8a9e8d287407398c4b4eb5a313bb31955ef007a72223223bac";
#从文件中获得的EneryId与该变量比较，主要起双重验证的作用

if ($dataInfo.coin.EnergyId -ne $eneryId) {
    "Enery Id 双重验证失败。" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
    return
}

$serviceUrl = "http://ec2-34-212-167-187.us-west-2.compute.amazonaws.com:8092/api/Avatars/"

$command = ""
$result = ""
$totalRecords = 0
$currentRecord = 0

foreach ($playerInfo in $energyTokenInfo) {
    $currentRecord++
    "一共 $($energyTokenInfo.Count) 记录,当前是第 $currentRecord 条."
    $address = ""
    $nftId = ""
    $totalRewardPoints = 0
    if ($null -ne $playerInfo.wallet) {
        "直接找到 Wallet: $($playerInfo.wallet)" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Green
        $address = $playerInfo.wallet
    }
    elseif ($null -ne $playerInfo.nft_id) {
        "找到 Nft id: $($playerInfo.nft_id)" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow
        $nftId = $playerInfo.nft_id
    }
    else {
        "没有找到 Wallet or Nft Id. PlayerInfo: $playerInfo " | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        continue;
    }
    $totalRewardPoints = $playerInfo.totalRewardPoints
    if ($null -eq $totalRewardPoints || "" -eq $totalRewardPoints) {
        "   不存在 totalRewardPoints 属性" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        continue;
    }
    elseif ($totalRewardPoints -le 0) {
        "   totalRewardPoints<=0,忽略" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Magenta 
        continue;   
    }
    $eneryAmount = 50 * $totalRewardPoints / 3;
    "   需要给其空投 $eneryAmount ENERGY." | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue  
    if ($nftId -ne "") {
        "   查询其 wallet address " | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow  
        $getAavatarServiceUrl = $serviceUrl + $nftId
        try {
            $command = "Invoke-WebRequest -Uri '" + $getAavatarServiceUrl + "' -Method Get -ContentType 'application/json'"
            # $getAllIslandResult = curl -X GET $getAllIslandUrl -H "accept: application/json"   
            $command | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
            $result = Invoke-Expression -Command $command 
            if ($result.StatusCode -ne 200) {
                "       请求失败，状态码: $($result.StatusCode),返回信息:$($result.Content)" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Red
                continue
            }
            $ResultObj = $result.Content | ConvertFrom-Json
            if ($null -eq $ResultObj.owner -or $ResultObj.owner -eq "") {
                "       wallete address 为空" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Red
                continue
            }
            $address = $ResultObj.owner;
            "       得到 wallete address: $address" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Green
        }
        catch {
            "根据 nft id 获取 nft 信息失败: $($_.Exception.Message)" | Tee-Object -FilePath $logFile -Append  | Write-Host -ForegroundColor Red
            "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host             
            continue    
        }
    }

    $eneryAmount9Zeroes = $eneryAmount * 1000000000;
    $command = "sui client pay --input-coins $eneryId --recipients $address --amounts $eneryAmount9Zeroes --json"
    $command | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Blue    
    try {
        $result = Invoke-Expression -Command $command     
        if (-not ('System.Object[]' -eq $result.GetType())) {
            "   执行Sui CLI 返回信息： $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            continue
        }
        $resultObj = $result | ConvertFrom-Json
        $find = $false
        foreach ($change in $resultObj.balanceChanges) {
            if ($change.owner.AddressOwner -eq $address -and $change.amount -eq $eneryAmount9Zeroes) {
                $find = $true
                "   空投成功!" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Green
                break;
            }
        }
        if ($find -eq $false) {
            "   没有发现空投信息." | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            continue
        }
    }
    catch {
        "   空投失败: $($_.Exception.Message)" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Red
        "   空投返回结果:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Red
        continue    
    }
}

"全部处理完毕，通过 $logFile 查看日志。" |  Write-Host -ForegroundColor Blue
