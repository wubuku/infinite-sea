$startLocation = $PSScriptRoot

$dataFile = "$startLocation\data.json"
if (-not (Test-Path -Path $dataFile -PathType Leaf)) {
    "文件 $dataFile 不存在 " | Write-Host  -ForegroundColor Red
    return
}

$ComeFromFile = Get-Content -Raw -Path $dataFile
$dataInfo = $ComeFromFile | ConvertFrom-Json


$now = Get-Date
$formattedNow = $now.ToString('yyyyMMddHHmmss')
$logFile = "$startLocation\map_whitelist_init_$formattedNow.log"

$addressesFile = "$startLocation\addresses.txt"
if (-not (Test-Path -Path $addressesFile -PathType Leaf)) {
    "加入白名单的地址列表文件 $addressesFile 不存在 " | Write-Host  -ForegroundColor Red
    return
}
$lines = Get-Content -Path $addressesFile

$addresses = @()
foreach ($line in $lines) {
    $line = $line.Trim()
    if ($line -ne "" -and (-not $addresses.Contains($line))) {
        $addresses += $line
    }
}

#成功添加数量
$addedCount = 0
#失败的数量
$failedCount = 0
#重复，所以更新的数量
$updatedCount = 0

$result = ""

foreach ($address in $addresses) {
    $command = "sui client call --package $($dataInfo.map.PackageId) --module map_aggregate --function add_to_whitelist --args $($dataInfo.map.Map) $($dataInfo.map.AdminCap) $address --json"
    $command | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    $result = Invoke-Expression -Command $command 
    if (-not ('System.Object[]' -eq $result.GetType())) {
        "添加 $address 到白名单时时返回信息： $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        $failedCount = $failedCount + 1
        continue
    }
    $resultObj = $result | ConvertFrom-Json
    $find = $false
    foreach ($objectChange in $resultObj.objectChanges) {
        if ($objectChange.type -eq "created" -and $objectChange.objectType -eq "0x2::dynamic_field::Field<address, bool>") {
            $addedCount = $addedCount + 1
            "地址： $address 已添加。" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Green
            $find = $true
        }
    
    }
    if ($find -eq $false) {
        $updatedCount = $updatedCount + 1
        "地址： $address 重复，已更新。" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
    }
}
"处理完毕：" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Green
"需要处理的地址：$($addresses.Length) 个,添加:$addedCount 个,因重复更新 $updatedCount 个,失败:$failedCount 个。" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Blue 


