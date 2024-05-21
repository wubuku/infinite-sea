
$farming = 0
$woodcutting = 1
#fishing=2
$mining = 3
$crafting = 6
#township=7
#sailing=8

$clock = "0x6"

$startLocation = Get-Location; 

$now = Get-Date
$formattedNow = $now.ToString('yyyyMMddHHmmss')
$logFile = "$startLocation\publish_$formattedNow.log"
$dataFile = "$startLocation\data.json"


$dataJson = New-Object -TypeName PSObject
$dataCoin = New-Object -TypeName PSObject
$dataCommon = New-Object -TypeName PSObject
$dataMain = New-Object -TypeName PSObject

$dataJson | Add-Member -MemberType NoteProperty -Name "coin" -Value $dataCoin
$dataJson | Add-Member -MemberType NoteProperty -Name "common" -Value $dataCommon
$dataJson | Add-Member -MemberType NoteProperty -Name "main" -Value $dataMain

#要不要测试挖矿
$testSkillProcessMining = $true
#要不要种一次棉花
$testSkillProcessFarming = $true
#要不要测试伐木进程一次？
$testSkillProcessWooding = $true


$playerName = 'John'




"------------------------------------- 重新发布 infinite-sea-coin -------------------------------------" | Tee-Object -FilePath $logFile -Append | Write-Host

# 重新发布infinite-sea-coin
$coinPath = Join-Path $startLocation "..\infinite-sea-coin"
#加下面这一句主要是为了后面不出现这样的目录：D:\git\infinite-sea\sui-contracts\pwsh\..\infinite-sea-coin
$coinPath = Get-Item -Path $coinPath
#$coinPath 其实是个对象
"切换目录到 $coinPath" | Tee-Object -FilePath $logFile -Append | Write-Host
if (-not (Test-Path -Path $coinPath)) {
    "目录 $coinPath 不存在 " | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
    return
}
Set-Location $coinPath

"发布之前将Move.toml文件恢复到初始状态" | Tee-Object -FilePath $logFile -Append | Write-Host
$file = "$coinPath\Move.toml"
if (-not (Test-Path -Path $file -PathType Leaf)) {
    "文件 $file 不存在 " | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
    return
}
$fileContent = Get-Content -Path $file 
for ($i = 0; $i -lt $fileContent.Count; $i++) {
    #Write-Host $fileContent[$i]
    if ($fileContent[$i].Contains('published-at')) {
        if ($fileContent[$i] -like "#*") {            
        }
        else {
            $fileContent[$i] = "#" + $fileContent[$i]
        }
    }
    if ($fileContent[$i].Contains('infinite_sea_coin =')) {
        $fileContent[$i] = 'infinite_sea_coin = "0x0"'
    }
}
$fileContent | Set-Content $file
"Move.toml文件恢复完成。" | Tee-Object -FilePath $logFile -Append | Write-Host


"开始发布合约 infinite_sea_coin..." | Tee-Object -FilePath $logFile -Append | Write-Host

$publishCoinJson = ""
$publishCoinJsonObj = $null
try {
    $publishCoinJson = sui client publish --gas-budget 900000000 --skip-fetch-latest-git-deps --skip-dependency-verification --json
    #发布成功之后返回的类型是 System.Object[]
    #Write-Host $publishCoinJson.GetType()
    #if ('System.String' -eq $publishCommonJson.GetType()-and $publishCommonJson | Test-Json) {}
    if (-not ('System.Object[]' -eq $publishCoinJson.GetType())) {
        "发布 infinite_sea_coin 合约失败: $publishCoinJson `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $publishCoinJsonObj = $publishCoinJson | ConvertFrom-Json
    #$temp_json = $publishCoinJsonObj | ConvertTo-Json
    #Write-Host $temp_json;
}
catch {
    "发布 infinite_sea_coin 合约失败: $($_.Exception.Message)" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
    "返回的结果为:$publishCoinJson" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation
    return
}

"休息一下，以免不能及时同步..." | Write-Host
Start-Sleep -Seconds 5
"休息完成，继续干活..." | Write-Host

$coinPackingId = ""
$treasuryCap = ""
try {
    foreach ($object in $publishCoinJsonObj.objectChanges) {
        if ($null -ne $object.packageId -and $object.packageId -ne "") {
            $coinPackingId = $object.packageId;
            $dataCoin | Add-Member -MemberType NoteProperty -Name "PackageId" -Value $coinPackingId
            "Coin PackageID: $coinPackingId" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Green
        }
        if ($null -ne $object.ObjectType -and $object.ObjectType -like "*TreasuryCap*") {
            $treasuryCap = $object.ObjectID
            $dataCoin | Add-Member -MemberType NoteProperty -Name "TreasuryCap" -Value $treasuryCap
            "Coin TreasuryCap ObjectID: $treasuryCap" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Green
        }
    }
}
catch {
    "解析Coin返回信息失败: $($_.Exception.Message)"   | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
    Set-Location $startLocation
    return
}
if ($coinPackingId -eq "") {
    "Cant find coin package id" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
    Set-Location $startLocation
    return
}
if ($treasuryCap -eq "") {
    "没能获取TreasuryCap ObjectID" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
    Set-Location $startLocation  
    return;
}

$coinDigest = $publishCoinJsonObj.digest
$dataCoin | Add-Member -MemberType NoteProperty -Name "Digest" -Value $coinDigest

"Coin digest: $coinDigest" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green


"更新Move.toml文件..." | Tee-Object -FilePath $logFile -Append | Write-Host
$fileContent = Get-Content -Path $file 
for ($i = 0; $i -lt $fileContent.Count; $i++) {
    #Write-Host $fileContent[$i]
    if ($fileContent[$i].Contains('published-at')) {
        $fileContent[$i] = 'published-at = "' + $coinPackingId + '"'
    }
    if ($fileContent[$i].Contains('infinite_sea_coin =')) {
        $fileContent[$i] = 'infinite_sea_coin = "' + $coinPackingId + '"'
    }
}
$fileContent | Set-Content $file
"Move.toml文件更新完成`n" | Tee-Object -FilePath $logFile -Append | Write-Host

"先给自己分配 Mint 100000000 ENERGY..." | Tee-Object -FilePath $logFile -Append | Write-Host
$mintJson = ""
$minAmout = '100000000'
$energyId = ""
try {
    $mintJson = sui client call --package $coinPackingId --module energy --function mint --args $treasuryCap $minAmout --gas-budget 19000000 --json
    if (-not ('System.Object[]' -eq $mintJson.GetType())) {
        "分配 Mint 失败: $mintJson `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $mintResultObject = $mintJson | ConvertFrom-Json;
    #$mintResultObjectToJson = $mintResultObject | ConvertTo-Json;
    #Write-Host $mintResultObjectToJson
    foreach ($object in $mintResultObject.objectChanges) {
        if ($object.ObjectType -like '0x2::coin::Coin*energy::ENERGY*') {
            $energyId = $object.objectId
            "得到了一个Coin<ENERGY> Id: $energyId" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Green
            $dataCoin | Add-Member -MemberType NoteProperty -Name "EnergyId" -Value $energyId
            break
        }
    }

    $mintedAmount = ''
    foreach ($object in $mintResultObject.balanceChanges) {
        if ($object.CoinType -like '*ENERGY*') {
            $mintedAmount = $object.Amount
            break
        }
    }
    if ($minAmout -ne $mintedAmount) {
        'Mint ENERGY Failed?' | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    "分配成功 Mint OK! `n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
}
catch {   
    "分配 Mint 失败: $($_.Exception.Message)"   | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red 
    Set-Location $startLocation
    return
}

if ($energyId -eq "") {
    "未能获取Coin<ENERGY> Id，请停下来检查一下什么情况。" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
}

Set-Location $startLocation


"------------------------------------- 重新发布 infinite-sea-common -------------------------------------" | Tee-Object -FilePath $logFile -Append | Write-Host
# 重新发布Common
$commonPath = Join-Path $startLocation "..\infinite-sea-common"
$commonPath = Get-Item -Path $commonPath
"切换目录到 Change Directory to $commonPath" | Tee-Object -FilePath $logFile -Append | Write-Host
if (-not (Test-Path -Path $commonPath)) {
    "目录 $commonPath 不存在 " | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
    return
}
Set-Location $commonPath

"发布之前将Move.toml文件恢复到初始状态" | Tee-Object -FilePath $logFile -Append | Write-Host
$file = "$commonPath\Move.toml"

if (-not (Test-Path -Path $file -PathType Leaf)) {
    "目录 $file 不存在 " | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
    return
}

$fileContent = Get-Content -Path $file 
for ($i = 0; $i -lt $fileContent.Count; $i++) {
    #Write-Host $fileContent[$i]
    if ($fileContent[$i].Contains('published-at')) {
        if ($fileContent[$i] -like "#*") {            
        }
        else {
            $fileContent[$i] = "#" + $fileContent[$i]
        }
    }
    if ($fileContent[$i].Contains('infinite_sea_common =')) {
        $fileContent[$i] = 'infinite_sea_common = "0x0"'
    }
}
$fileContent | Set-Content $file
"Move.toml文件恢复完成" | Tee-Object -FilePath $logFile -Append | Write-Host

"开始发布Common合约 Publish Common contract..." | Tee-Object -FilePath $logFile -Append | Write-Host

$publishCommonJson = ""
$publishCommonObj = $null
try {
    $publishCommonJson = sui client publish --gas-budget 900000000 --skip-fetch-latest-git-deps --skip-dependency-verification --json
    #发布成功之后返回的类型是 System.Object[]
    #Write-Host $publishCommonJson.GetType()
    #if ('System.String' -eq $publishCommonJson.GetType()-and $publishCommonJson | Test-Json) {}
    if (-not ('System.Object[]' -eq $publishCommonJson.GetType())) {
        "Publish Common contract failed: $publishCommonJson" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $publishCommonObj = $publishCommonJson | ConvertFrom-Json

    #$jsonAgain = $publishCommonObj | ConvertTo-Json

    #Write-Host $jsonAgain
}
catch {
    "发布Common合约失败 Publish Common contract failed: $($_.Exception.Message)" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
    "返回的结果为:$publishCommonJson" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation
    return
}


$commonDigest = $publishCommonObj.digest
"摘要 Common Package digest: $commonDigest" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green

$dataCommon | Add-Member -MemberType NoteProperty -Name "Digest" -Value $commonDigest

$commonPackageId = ''
$ItemProductionTableId = ''
$commonPublisherId = ''
$experienceTableId = ''
$itemTableId = ''
$itemCreationTableId = ''

foreach ($object in $publishCommonObj.objectChanges) {
    if ($null -ne $object.objectType) {
        if ('0x2::package::Publisher' -eq $object.objectType) {
            $commonPublisherId = $object.objectId
            "Common contract Publisher:  $commonPublisherId" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
            if ($null -eq $dataCommon.Publisher -or $dataCommon.Publisher -eq "") {
                $dataCommon | Add-Member -MemberType NoteProperty -Name "Publisher" -Value $commonPublisherId
            }
        }
        elseif ($object.objectType -like '*item_production::ItemProductionTable') {
            $ItemProductionTableId = $object.objectId
            $dataCommon | Add-Member -MemberType NoteProperty -Name "ItemProductionTable" -Value $ItemProductionTableId
            "Common contract ItemProductionTable:    $ItemProductionTableId" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
        }
        elseif ($object.objectType -like '*item::ItemTable') {
            $itemTableId = $object.objectId
            $dataCommon | Add-Member -MemberType NoteProperty -Name "ItemTable" -Value $itemTableId
            "Common contract ItemTable:  $itemTableId" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
        }
        elseif ($object.objectType -like '*experience_table::ExperienceTable') {
            $experienceTableId = $object.objectId
            $dataCommon | Add-Member -MemberType NoteProperty -Name "ExperienceTable" -Value $experienceTableId
            "Common contract ExperienceTable:    $experienceTableId" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
        }
        elseif ($object.objectType -like '*item_creation::ItemCreationTable') {
            $itemCreationTableId = $object.objectId
            $dataCommon | Add-Member -MemberType NoteProperty -Name "ItemCreationTable" -Value $itemCreationTableId
            "Common contract ItemCreationTable:  $itemCreationTableId" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
        }
    }
    if ($null -ne $object.packageId) {
        $commonPackageId = $object.packageId
        $dataCommon | Add-Member -MemberType NoteProperty -Name "PackageId" -Value $commonPackageId 
        "Common contract packageId:  $commonPackageId" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
    }
}

if ($commonPackageId -eq '') {
    "没能获取PackageId,发布失败。" | Tee-Object -FilePath $logFile -Append | Write-Host -BackgroundColor Red -ForegroundColor Black
}


"更新Move.toml文件..." | Tee-Object -FilePath $logFile -Append | Write-Host
$file = "$commonPath\Move.toml"
$fileContent = Get-Content -Path $file 
for ($i = 0; $i -lt $fileContent.Count; $i++) {
    #Write-Host $fileContent[$i]
    if ($fileContent[$i].Contains('published-at')) {
        $fileContent[$i] = 'published-at = "' + $commonPackageId + '"'
    }
    if ($fileContent[$i].Contains('infinite_sea_common =')) {
        $fileContent[$i] = 'infinite_sea_common = "' + $commonPackageId + '"'
    }
}
$fileContent | Set-Content $file
"Move.toml文件更新完成。 `n" | Tee-Object -FilePath $logFile -Append | Write-Host


"休息一下，以免不能及时同步..." | Write-Host
Start-Sleep -Seconds 5
"休息完成，继续干活..." | Write-Host


"现在开始创建检验等级表格..." | Tee-Object $logFile -Append | Write-Host
$level0 = [PSCustomObject]@{
    Level      = 0
    Experience = 0
    Difference = 0
}
$level1 = [PSCustomObject]@{
    Level      = 1
    Experience = 0
    Difference = 0
}
$level2 = [PSCustomObject]@{
    Level      = 2
    Experience = 83
    Difference = 83
}
$level3 = [PSCustomObject]@{
    Level      = 3
    Experience = 174
    Difference = 91
}

$levelArray = @($level0, $level1, $level2, $level3)

foreach ($level in $levelArray) {
    try {
        $result = sui client call --package $commonPackageId --module experience_table_aggregate --function add_level --args $experienceTableId $commonPublisherId  $level.Level $level.Experience $level.Difference --gas-budget 11000000 --json
        if (-not ('System.Object[]' -eq $result.GetType())) {
            "添加等级 $level 相关信息时返回信息 $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            Set-Location $startLocation
            return
        }
        "添加等级 $level 信息成功" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
    }
    catch {
        "添加等级 $level 相关信息失败: $($_.Exception.Message)" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
        Set-Location $startLocation
        return    
    }
}

"创建检验等级表格完成。`n" | Tee-Object $logFile -Append | Write-Host 


$itemDataFile = "$startLocation\item.json"
if (-not (Test-Path -Path $itemDataFile -PathType Leaf)) {
    "文件 $itemDataFile 不存在 " | Write-Host  -ForegroundColor Red
    Set-Location $startLocation
    return
}
$itemDataJson = Get-Content -Raw -Path $itemDataFile
$itemData = $itemDataJson | ConvertFrom-Json


$itemArray = @($itemData.ItemUnused, $itemData.ItemPotatoSeeds, $itemData.ItemPotatoes, $itemData.ItemCottonSeeds, $itemData.ItemCottons, $itemData.ItemBronzeBar, $itemData.ItemNormalLogs, 
    $itemData.ItemShip, $itemData.ItemCopperOre, $itemData.ItemTinOre, $itemData.ResourceTypeWoodcutting, $itemData.ResourceTypeFishing, $itemData.ResourceTypeMining)


"增加几个 Item ..." | Tee-Object $logFile -Append | Write-Host
foreach ($item in $itemArray) {
    try {
        $result = sui client call --package $commonPackageId --module item_aggregate --function create --args $item.ItemId $commonPublisherId $item.Name  $item.RequiredForCompletion $item.SellsFor $itemTableId --gas-budget 11000000 --json
        if (-not ('System.Object[]' -eq $result.GetType())) {
            "添加Item $item 相关信息时返回信息 $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            Set-Location $startLocation
            return
        }
        "添加Item $item 信息成功" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
    }
    catch {
        "添加Item $item 相关信息失败: $($_.Exception.Message)" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
        Set-Location $startLocation
        return    
    }
}
"添加了" + $itemArray.Count + "个Item。`n" | Tee-Object $logFile -Append | Write-Host 


"------------------------------------- 重新发布 infinite-sea -------------------------------------" | Tee-Object -FilePath $logFile -Append | Write-Host

# 重新发布Infinite-sea
$mainPath = Join-Path $startLocation "..\infinite-sea"
$mainPath = Get-Item -Path $mainPath
"切换目录到 Change Directory to $mainPath" | Tee-Object -FilePath $logFile -Append | Write-Host
if (-not (Test-Path -Path $mainPath)) {
    "目录 $mainPath 不存在 " | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
    return
}
Set-Location $mainPath

"发布之前将Move.toml文件恢复到初始状态..." | Tee-Object -FilePath $logFile -Append | Write-Host
$file = "$mainPath\Move.toml"
if (-not (Test-Path -Path $file -PathType Leaf)) {
    "文件 $file 不存在 " | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
    return
}

$fileContent = Get-Content -Path $file 
for ($i = 0; $i -lt $fileContent.Count; $i++) {
    #Write-Host $fileContent[$i]
    if ($fileContent[$i].Contains('published-at')) {
        if ($fileContent[$i] -like "#*") {            
        }
        else {
            $fileContent[$i] = "#" + $fileContent[$i]
        }
    }
    if ($fileContent[$i].Contains('infinite_sea =')) {
        $fileContent[$i] = 'infinite_sea = "0x0"'
    }
}
$fileContent | Set-Content $file
"Move.toml文件恢复完成。`n" | Tee-Object -FilePath $logFile -Append | Write-Host


"开始发布合约 Publish infinite_sea contract..." | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Blue
$publishMainJson = ""
try {
    $publishMainJson = sui client publish --gas-budget 900000000 --skip-fetch-latest-git-deps --skip-dependency-verification --json
    #发布成功之后返回的类型是 System.Object[]
    #Write-Host $publishMainJson.GetType()
    #if ('System.String' -eq $publishCommonJson.GetType()-and $publishCommonJson | Test-Json) {}
    if (-not ('System.Object[]' -eq $publishMainJson.GetType())) {
        "Publish infinite-sea contract failed: $publishMainJson" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
}
catch {
    "发布 infinite-sea 合约失败: $($_.Exception.Message)" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
    Set-Location $startLocation
    return
}
$publishMainObj = $null
try {
    $publishMainObj = $publishMainJson | ConvertFrom-Json
}
catch {
    "不能将发布返回的结果转化为JSON对象`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
    $publishMainJson | Tee-Object -FilePath $logFile -Append | Write-Host 
    Set-Location $startLocation
    return
}

#$jsonAgain = $publishMainObj | ConvertTo-Json
#Write-Host $jsonAgain
"infinite-sea 发布完成。`n" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
$MainDigest = $publishMainObj.digest
"摘要 digest: $MainDigest"  |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Green
$dataMain | Add-Member -MemberType NoteProperty -Name "Digest" -Value $MainDigest 

$mapAdminCap = ""
$upgradeCap = ""
$skillProcessTableId = ""
$mainPublisherId = ""
$mainPackageId = ""
$rosterTableId = ""
$mapId = ""

foreach ($object in $publishMainObj.objectChanges) {
    if ($null -ne $object.objectType) {
        if ('0x2::package::Publisher' -eq $object.objectType) {
            $mainPublisherId = $object.objectId
            "infinite-sea contract Publisher:  $mainPublisherId" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
            if ($null -eq $dataMain.Publisher -or $dataMain.Publisher -eq "") {
                $dataMain | Add-Member -MemberType NoteProperty -Name "Publisher" -Value $mainPublisherId 
            }
        }
        elseif ('0x2::package::UpgradeCap' -eq $object.objectType) {
            $upgradeCap = $object.objectId
            $dataMain | Add-Member -MemberType NoteProperty -Name "UpgradeCap" -Value $upgradeCap 
            "infinite-sea contract UpgradeCap:  $upgradeCap" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
        }
        elseif ($object.objectType -like '*skill_process::SkillProcessTable') {
            $skillProcessTableId = $object.objectId
            $dataMain | Add-Member -MemberType NoteProperty -Name "SkillProcessTable" -Value $skillProcessTableId 
            "infinite-sea contract skill_process::SkillProcessTable id:   $skillProcessTableId" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
        }
        elseif ($object.objectType -like '*roster::RosterTable') {
            $rosterTableId = $object.objectId
            $dataMain | Add-Member -MemberType NoteProperty -Name "RosterTable" -Value $rosterTableId 
            "infinite-sea contract roster::RosterTable id:  $rosterTableId" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
        }
        elseif ($object.objectType -like '*map::Map') {
            $mapId = $object.objectId
            $dataMain | Add-Member -MemberType NoteProperty -Name "Map" -Value $mapId 
            "infinite-sea contract map::Map id:    $mapId" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
        }
        elseif ($object.objectType -like '*map::AdminCap') {
            $mapAdminCap = $object.objectId
            $dataMain | Add-Member -MemberType NoteProperty -Name "AdminCap" -Value $mapAdminCap 
            "infinite-sea contract map::AdminCap id:  $mapAdminCap" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
        }
    }
    if ($null -ne $object.packageId) {
        $mainPackageId = $object.packageId
        $dataMain | Add-Member -MemberType NoteProperty -Name "PackageId" -Value $mainPackageId 
        "infinite-sea contract packageId:  $mainPackageId" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
    }
}
if ($mainPackageId -eq '') {
    "没能获取PackageId,发布失败" | Tee-Object -FilePath $logFile -Append | Write-Host -BackgroundColor Red -ForegroundColor Black
}

"更新Move.toml文件..." | Tee-Object -FilePath $logFile -Append | Write-Host
$fileContent = Get-Content -Path $file 
for ($i = 0; $i -lt $fileContent.Count; $i++) {
    #Write-Host $fileContent[$i]
    if ($fileContent[$i].Contains('published-at')) {
        $fileContent[$i] = 'published-at = "' + $mainPackageId + '"'
    }
    if ($fileContent[$i].Contains('infinite_sea =')) {
        $fileContent[$i] = 'infinite_sea = "' + $mainPackageId + '"'
    }
}
$fileContent | Set-Content $file
"Move.toml文件更新完成。 `n" | Tee-Object -FilePath $logFile -Append | Write-Host

"`n休息一下，以免不能及时同步..." | Write-Host
Start-Sleep -Seconds 5
"休息完成，继续干活...· `n" | Write-Host

"`n创建一个PLAYER..." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
$playId = ""
try {
    $result = sui client call --package $mainPackageId --module player_aggregate --function create --args $playerName --gas-budget 11000000 --json
    if (-not ('System.Object[]' -eq $result.GetType())) {
        "创建Player时返回信息 $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $resultObj = $result | ConvertFrom-Json
    foreach ($object in $resultObj.objectChanges) {
        if ($object.objectType -like "*player::Player") {
            $playId = $object.objectId
            $dataMain | Add-Member -MemberType NoteProperty -Name "Player" -Value $playId 
            "创建成功,Player Id: $playId`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
            break;   
        }
    }
}
catch {
    "创建Player失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
    Set-Location $startLocation
    return    
}

"休息一下，以免新生成的 Player 不能使用..." | Write-Host
Start-Sleep -Seconds 2
"休息完成，继续干活...· `n" | Write-Host

$coordinates_x = 50
$coordinates_y = 50

$islandResources = $itemData.ItemCottonSeeds, $itemData.ResourceTypeWoodcutting, $itemData.ResourceTypeMining , $itemData.ItemCottons, $itemData.ItemNormalLogs, $itemData.ItemCopperOre
$islandResourceIds = @()
$islandResourceQuantities = @()
#$islandResourceQuantities = (200, 100, 200, 200)
"`n在地图上添加一个小岛，坐标($coordinates_x,$coordinates_y)" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Green
"附加以下资源：" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
foreach ($resouce in $islandResources) {
    "       $($resouce.Name) ($($resouce.ChineseName)),数量 $($resouce.Quantity)"  | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    $islandResourceIds += $resouce.ItemId
    $islandResourceQuantities += ($resouce.Quantity)
}
$islandResources_ = "[" + ($islandResourceIds -join ",") + "]"
$islandResourceQuantities_ = "[" + ($islandResourceQuantities -join ",") + "]"
try {
    $command = "sui client call --package $mainPackageId --module map_aggregate --function add_island --args $mapId $mapAdminCap $coordinates_x $coordinates_y $islandResources_ $islandResourceQuantities_  --gas-budget 11000000 --json"
    $command | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
    $result = Invoke-Expression -Command $command
    if (-not ('System.Object[]' -eq $result.GetType())) {
        "调用接口返回信息: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $resultObj = $result | ConvertFrom-Json   
    "添加小岛成功。 `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Green 
}
catch {
    "添加小岛失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
    "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation 
    return    
}


$claimFile = "$startLocation\claim_island.json"

$rosterIds = @()
$skillProcessIds = @()
"`n用户宣称Claim这个小岛($coordinates_x,$coordinates_y)..." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
try {
    $result = sui client call --package $mainPackageId --module player_aggregate --function claim_island --args $playId $mapId $coordinates_x $coordinates_y $clock $rosterTableId $skillProcessTableId --gas-budget 4999000000 --json
    if (-not ('System.Object[]' -eq $result.GetType())) {
        "调用接口返回信息: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $resultObj = $result | ConvertFrom-Json   
    "宣称小岛成功。 `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor  Yellow 
    foreach ($obj in $resultObj.objectChanges) {
        if ($obj.objectType -like "*::roster::Roster") {
            $rosterIds += $obj.objectId
        }
        elseif ($obj.objectType -like "*::skill_process::SkillProcess") {
            $skillProcessIds += $obj.objectId
        }
    }
    #$jsonAgain = $resultObj | ConvertTo-Json
    #$jsonAgain | Tee-Object -FilePath $claimFile -Append 
    #$jsonAgain | Set-Content -Path $claimFile 
}
catch {
    "宣称Claim小岛失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
    "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation 
    return    
}
if ($rosterIds.Length -gt 0) {
    "获取Player的船队信息：" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor  Yellow 
    $playerRostersFile = "$startLocation\rosters.json"
    $RosterData = New-Object -TypeName PSObject
    $resultRosterInfo = ""
    foreach ($rosterId in $rosterIds) {        
        try {
            $resultRosterInfo = sui client object $rosterId --json 
            if (-not ('System.Object[]' -eq $resultRosterInfo.GetType())) {
                "获取Roster $rosterId 信息时返回 $resultRosterInfo" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
                Set-Location $startLocation
                return
            }
            $resutJson = $resultRosterInfo | ConvertFrom-Json
            $sequence_number = $resutJson.content.fields.roster_id.fields.sequence_number
            "   船队编号： $sequence_number，船队Id: $rosterId" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Green
            $RosterData | Add-Member -MemberType NoteProperty -Name $sequence_number -Value $rosterId
        }
        catch {
            "获取船队 $rosterId 信息失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
            "返回的结果为:$resultRosterInfo" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
            Set-Location $startLocation
            return    
        }
    }
    $RosterData | ConvertTo-Json | Tee-Object -FilePath $playerRostersFile | Write-Host -ForegroundColor Green
}
else {
    "没有给Player分配船队？船队数量为0。请检查原因" | Tee-Object -FilePath $logFile -Append  | Write-Host -ForegroundColor Red
    Set-Location $startLocation
    return    
}

$SkillProcessCraftingId = ""
$SkillProcessFarming1Id = ""
$SkillProcessFarming2Id = ""
$SkillProcessMiningId = ""
$SkillProcessWoodingId = ""
if ($skillProcessIds.Length -gt 0) {
    "获取Player的技能信息：" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor  Yellow 
    $resultSkillInfo = ""
    foreach ($skillId in $skillProcessIds) {        
        try {
            $resultSkillInfo = sui client object $skillId --json 
            if (-not ('System.Object[]' -eq $resultSkillInfo.GetType())) {
                "获取技能过程 $skillId 信息时返回 $resultSkillInfo" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
                Set-Location $startLocation
                return
            }
            $resutJson = $resultSkillInfo | ConvertFrom-Json
            $sequence_number = $resutJson.content.fields.skill_process_id.fields.sequence_number
            $skill_type = $resutJson.content.fields.skill_process_id.fields.skill_type
            if ($skill_type -eq $farming) {
                if ($sequence_number -eq 0) {
                    $SkillProcessFarming1Id = $skillId
                    $dataMain | Add-Member -MemberType NoteProperty -Name "SkillProcessFarming1" -Value $skillId 
                    "种棉花进程1(Sequence number:$sequence_number,Skill type:$skill_type): $skillId`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
                }
                elseif ($sequence_number -eq 1) {
                    $SkillProcessFarming2Id = $skillId
                    $dataMain | Add-Member -MemberType NoteProperty -Name "SkillProcessFarming2" -Value $skillId 
                    "种棉花进程2(Sequence number:$sequence_number,Skill type:$skill_type): $skillId`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
                }
                else {
                    "种棉花？【Sequence number:$sequence_number,Skill type:$skill_type】: $skillId`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
                }
            }
            elseif ($skill_type -eq $woodcutting) {
                $SkillProcessWoodingId = $skillId
                $dataMain | Add-Member -MemberType NoteProperty -Name "SkillProcessWooding" -Value $skillId 
                "伐木进程(Sequence number:$sequence_number,Skill type:$skill_type): $skillId`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
            }
            elseif ($skill_type -eq $mining) {
                $SkillProcessMiningId = $skillId
                $dataMain | Add-Member -MemberType NoteProperty -Name "SkillProcessMining" -Value $skillId 
                "挖矿进程(Sequence number:$sequence_number,Skill type:$skill_type): $skillId`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
            }
            elseif ($skill_type -eq $crafting) {
                $SkillProcessCraftingId = $skillId
                $dataMain | Add-Member -MemberType NoteProperty -Name "SkillProcessCrafting" -Value $skillId 
                "造船进程(Sequence number:$sequence_number,Skill type:$skill_type): $skillId`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
                
            }
            else {
                "错误，无法识别(Sequence number:$sequence_number,Skill type:$skill_type): $skillId`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
                Set-Location $startLocation
            }
            
        }
        catch {
            "获取技能过程 $skillId 信息失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
            "返回的结果为:$resultSkillInfo" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
            Set-Location $startLocation
            return    
        }
    }
}
else {
    "没有给 Player 分配技能吗，请检查原因。" | Tee-Object -FilePath $logFile -Append  | Write-Host -ForegroundColor Red
    Set-Location $startLocation
    return    
}

if ($testSkillProcessMining) {
    $itemCreationMiningId = $null
    #挖矿一次耗费的时间（秒）
    $miningTime = 3
    $resource_cost = 1
    $requirements_level = 1
    $base_quantity = 1
    $base_experience = 10
    $energy_cost = 1
    $success_rate = 100
    "`n生成挖矿配方 Item Creation..." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    try {
        $result = sui client call --package $commonPackageId --module item_creation_aggregate --function create --args $mining $($itemData.ItemCopperOre.ItemId) $commonPublisherId $resource_cost $requirements_level $base_quantity $base_experience $miningTime $energy_cost $success_rate  $itemCreationTableId --gas-budget 44000000 --json
        if (-not ('System.Object[]' -eq $result.GetType())) {
            "制作挖矿配方返回信息: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            Set-Location $startLocation
            return
        }
        $resultObj = $result | ConvertFrom-Json   
        foreach ($object in $resultObj.objectChanges) {
            if ($object.objectType -like "*::item_creation::ItemCreation") {
                $itemCreationMiningId = $object.objectId
                $dataCommon | Add-Member -MemberType NoteProperty -Name "ItemCreationMining" -Value $itemCreationMiningId 
                "挖矿配方制作完成。 ItemCreationMining Id: $itemCreationWoodingId`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
                break;   
            }
        } 
    }
    catch {
        "制作挖矿配方失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
        Set-Location $startLocation 
        return    
    }
    if ($null -eq $itemCreationMiningId) {
        "ItemCreationMining Id 没有值，一定发生了什么。 `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation 
        return    
    }
    
    "挖矿开始前，先看一下Player当前拥有的资源：" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White
    $payerMiningResouceQuantityBeforeStart = 0
    $playerCopperOreQuantityBeforeStart = 0
    try {
        $result = sui client object $playId --json
        if (-not ('System.Object[]' -eq $result.GetType())) {
            "获取Player信息失败: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            Set-Location $startLocation
            return
        }
        $resultObj = $result | ConvertFrom-Json   
        #"Player 手上有如下资源：" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White
        foreach ($object in $resultObj.content.fields.inventory) {
            if ($($object.fields.item_id -eq $itemData.ResourceTypeMining.ItemId)) {
                $payerMiningResouceQuantityBeforeStart = $($object.fields.quantity)
                "Item Id: $($object.fields.item_id) ,数量:$($object.fields.quantity), $($itemData.ResourceTypeMining.ChineseName)[$($itemData.ResourceTypeMining.Name)]" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow
            }
            elseif ($($object.fields.item_id -eq $itemData.ItemCopperOre.ItemId)) {
                $playerCopperOreQuantityBeforeStart = $($object.fields.quantity)
                "Item Id: $($object.fields.item_id) ,数量:$($object.fields.quantity), $($itemData.ItemCopperOre.ChineseName)[$($itemData.ItemCopperOre.Name)]" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Green
            }
            else {
                "Item Id: $($object.fields.item_id) ,数量:$($object.fields.quantity)" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White
            }
        } 
    }
    catch {
        "获取Player信息失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
        Set-Location $startLocation 
        return    
    }

    $batchSize = 1
    "`n开始挖矿..." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    try {
        $result = sui client call --package $mainPackageId --module skill_process_service --function start_creation --args $SkillProcessMiningId $batchSize $playId $itemCreationMiningId $clock $energyId --gas-budget 11000000 --json
        if (-not ('System.Object[]' -eq $result.GetType())) {
            "开始挖矿时返回信息: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            Set-Location $startLocation
            return
        }
        $resultObj = $result | ConvertFrom-Json    
        "挖矿已经开始..." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    }
    catch {
        "开始挖矿失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
        Set-Location $startLocation 
        return    
    }


    "挖矿开始后，再看一下Player当前拥有的资源：" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White
    $payerMiningResouceQuantityAfterStart = 0
    $playerCopperOreQuantityAfterStart = 0
    try {
        $result = sui client object $playId --json
        if (-not ('System.Object[]' -eq $result.GetType())) {
            "获取Player信息: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            Set-Location $startLocation
            return
        }
        $resultObj = $result | ConvertFrom-Json   
        #"Player 手上有如下资源：" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White
        foreach ($object in $resultObj.content.fields.inventory) {
            if ($($object.fields.item_id -eq $itemData.ResourceTypeMining.ItemId)) {
                $payerMiningResouceQuantityAfterStart = $($object.fields.quantity)
                "Item Id: $($object.fields.item_id) ,数量:$($object.fields.quantity), $($itemData.ResourceTypeMining.ChineseName)[$($itemData.ResourceTypeMining.Name)]，" +
                "可以看到数量减少了: " + ($payerMiningResouceQuantityBeforeStart - $payerMiningResouceQuantityAfterStart ) |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow
            }
            elseif ($($object.fields.item_id -eq $itemData.ItemCopperOre.ItemId)) {
                $playerCopperOreQuantityAfterStart = $($object.fields.quantity)
                "Item Id: $($object.fields.item_id) ,数量:$($object.fields.quantity), $($itemData.ItemCopperOre.ChineseName)[$($itemData.ItemCopperOre.Name)]" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Green
            }
            else {
                "Item Id: $($object.fields.item_id) ,数量:$($object.fields.quantity)" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White
            }
        } 
    }
    catch {
        "获取Player信息失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
        Set-Location $startLocation 
        return    
    }

    "`n挖矿中...需要等待 ($miningTime * $batchSize) 秒钟..." | Write-Host
    Start-Sleep -Seconds ($miningTime * $batchSize)
    "该收工了...· `n" | Write-Host


    "`n来，现在结束挖矿..." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    try {
        $result = sui client call --package $mainPackageId --module skill_process_aggregate --function complete_creation --args $SkillProcessMiningId $playId $itemCreationMiningId $experienceTableId $clock --gas-budget 42000000 --json
        if (-not ('System.Object[]' -eq $result.GetType())) {
            "结束挖矿流程返回信息: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            Set-Location $startLocation
            return
        }
        $resultObj = $result | ConvertFrom-Json    
        "挖矿流程已经结束。" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    }
    catch {
        "结束挖矿流程失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
        Set-Location $startLocation 
        return    
    }


    "挖矿结束后，再来看一下Player当前拥有的资源：" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White
    $payerMiningResouceQuantityAfterFinish = 0
    $playerCopperOreQuantityAfterFinish = 0
    try {
        $result = sui client object $playId --json
        if (-not ('System.Object[]' -eq $result.GetType())) {
            "获取Player信息: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            Set-Location $startLocation
            return
        }
        $resultObj = $result | ConvertFrom-Json   
        foreach ($object in $resultObj.content.fields.inventory) {
            if ($($object.fields.item_id -eq $itemData.ResourceTypeMining.ItemId)) {
                $payerMiningResouceQuantityAfterFinish = $($object.fields.quantity)
                "Item Id: $($object.fields.item_id) ,数量:$($object.fields.quantity), $($itemData.ResourceTypeMining.ChineseName)[$($itemData.ResourceTypeMining.Name)]" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow
            }
            elseif ($($object.fields.item_id -eq $itemData.ItemCopperOre.ItemId)) {
                $playerCopperOreQuantityAfterFinish = $($object.fields.quantity)
                "Item Id: $($object.fields.item_id) ,数量:$($object.fields.quantity), $($itemData.ItemCopperOre.ChineseName)[$($itemData.ItemCopperOre.Name)]，" + 
                "可以看到数量增加了: " + ($playerCopperOreQuantityAfterFinish - $playerCopperOreQuantityBeforeStart) |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Green
            
            }
            else {
                "Item Id: $($object.fields.item_id) ,数量:$($object.fields.quantity)" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White
            }
        } 
    }
    catch {
        "获取Player信息失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
        Set-Location $startLocation 
        return    
    }

}


if ($testSkillProcessFarming) {
    "`n现在开始创建一个配方Item Production,使用棉花种子种植棉花..." | Tee-Object $logFile -Append | Write-Host 
    $itemCottonSeedsId = "[" + $($itemData.ItemCottonSeeds.ItemId) + "]"
    $itemProductionCottonSeedsToCottonId = ''
    $costTime = 5
    try {
        $result = sui client call --package $commonPackageId --module item_production_aggregate --function create --args '0' $itemData.ItemCottons.ItemId $commonPublisherId $itemCottonSeedsId '[1]' '1' '5' '85' $costTime '5' '100' $ItemProductionTableId --gas-budget 11000000 --json
        if (-not ('System.Object[]' -eq $result.GetType())) {
            "添加配方Item Production(种植棉花)时返回信息: $result `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            Set-Location $startLocation
            return
        }
        "添加配方Item Production(种植棉花)信息成功。" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
        $createItemProductionObj = $result | ConvertFrom-Json
        foreach ($object in $createItemProductionObj.objectChanges) {
            if ($object.objectType -like '*item_production::ItemProduction') {
                $itemProductionCottonSeedsToCottonId = $object.objectId   
                $dataCommon | Add-Member -MemberType NoteProperty -Name "ItemProductionFarming" -Value $itemProductionCottonSeedsToCottonId         
                "该配方ItemProductionId为: $itemProductionCottonSeedsToCottonId `n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
                break
            }
        }    
    }
    catch {
        "添加配方Item Production(种植棉花)失败: $($_.Exception.Message)" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
        Set-Location $startLocation
        return    
    }
    if ($itemProductionCottonSeedsToCottonId -eq '') {
        "没有获取新增配方Item Production(种植棉花)的Id,请检查原因" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
        Set-Location $startLocation
        return  
    }

    # $skillProcessId = ""
    # "`n创建一个生产流程(farming)" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    # try {
    #     $result = sui client call --package $mainPackageId --module skill_process_aggregate --function create --args $farming $playId '1' $playId $skillProcessTableId --gas-budget 11000000 --json
    #     if (-not ('System.Object[]' -eq $result.GetType())) {
    #         "创建生产流程返回信息: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
    #         Set-Location $startLocation
    #         return
    #     }
    #     $resultObj = $result | ConvertFrom-Json
    #     foreach ($object in $resultObj.objectChanges) {
    #         if ($object.objectType -like "*skill_process::SkillProcess") {
    #             $skillProcessId = $object.objectId
    #             $dataMain | Add-Member -MemberType NoteProperty -Name "SkillProcessFarming" -Value $skillProcessId 
    #             "创建成功,SkillProcess Id: $skillProcessId`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
    #             break;   
    #         }
    #     }
    # }
    # catch {
    #     "创建生产流程失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
    #     "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    #     Set-Location $startLocation 
    #     return    
    # }
    # if ($skillProcessId -eq "") {
    #     "虽然执行了创建生产流程的接口，但是没有获取 SkillProcess Id，所以请检查原因。" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
    #     Set-Location $startLocation 
    #     return    
    # }

    $batchSize = 1

    "`n开始种棉花流程..." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    try {
        $result = sui client call --package $mainPackageId --module skill_process_service --function start_production --args $SkillProcessFarming1Id $batchSize $playId $itemProductionCottonSeedsToCottonId $clock $energyId --gas-budget 11000000 --json
        if (-not ('System.Object[]' -eq $result.GetType())) {
            "开始种棉花流程返回信息: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            Set-Location $startLocation
            return
        }
        $resultObj = $result | ConvertFrom-Json    
        "种棉花流程已经开始..." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    }
    catch {
        "开始种棉花流程失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
        Set-Location $startLocation 
        return    
    }


    "休息一下，因为结束种棉花流程需要等待$costTime 秒钟..." | Write-Host
    Start-Sleep -Seconds ($costTime * $batchSize)
    "休息完成，继续干活...· `n" | Write-Host

    "`n结束种棉花流程..." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    try {
        $result = sui client call --package $mainPackageId --module skill_process_aggregate --function complete_production --args $SkillProcessFarming1Id $playId $itemProductionCottonSeedsToCottonId $experienceTableId $clock --gas-budget 42000000 --json
        if (-not ('System.Object[]' -eq $result.GetType())) {
            "结束种棉花流程返回信息: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            Set-Location $startLocation
            return
        }
        $resultObj = $result | ConvertFrom-Json    
        "种棉花流程已经结束。" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    }
    catch {
        "结束种棉花流程失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
        Set-Location $startLocation 
        return    
    }
}

if ($testSkillProcessWooding) {
    $itemCreationWoodingId = $null
    #伐木一次耗费的时间（秒）
    $woodcuttingTime = 3
    "`n搞一个伐木配方 Item Creation..." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    try {
        $result = sui client call --package $commonPackageId --module item_creation_aggregate --function create --args $woodcutting $($itemData.ItemNormalLogs.ItemId) $commonPublisherId 1 1 1 10 $woodcuttingTime 5 100  $itemCreationTableId --gas-budget 44000000 --json
        if (-not ('System.Object[]' -eq $result.GetType())) {
            "制作伐木配方返回信息: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            Set-Location $startLocation
            return
        }
        $resultObj = $result | ConvertFrom-Json   
        foreach ($object in $resultObj.objectChanges) {
            if ($object.objectType -like "*::item_creation::ItemCreation") {
                $itemCreationWoodingId = $object.objectId
                $dataCommon | Add-Member -MemberType NoteProperty -Name "ItemCreationWooding" -Value $itemCreationWoodingId 
                "伐木配方制作完成。 ItemCreationWooding Id: $itemCreationWoodingId`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
                break;   
            }
        } 
    }
    catch {
        "制作伐木配方失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
        Set-Location $startLocation 
        return    
    }
    if ($null -eq $itemCreationWoodingId) {
        "ItemCreationWooding Id 没有值，一定发生了什么。 `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation 
        return    
    }

    "`nPlayer获得了小岛之后，他拥有了一些伐木资源，他打算伐木...." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor White
    "那么首先创建一个伐木的Skill Process吧...." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor White

    # $skillProcessWoodingId = $null
    # try {
    #     $result = sui client call --package $mainPackageId --module skill_process_aggregate --function create --args $woodcutting $playId '0' $playId $skillProcessTableId --gas-budget 11000000 --json
    #     if (-not ('System.Object[]' -eq $result.GetType())) {
    #         "创建伐木训练过程返回信息: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
    #         Set-Location $startLocation
    #         return
    #     }
    #     $resultObj = $result | ConvertFrom-Json   
    #     foreach ($object in $resultObj.objectChanges) {
    #         if ($object.objectType -like "*::skill_process::SkillProcess") {
    #             $skillProcessWoodingId = $object.objectId
    #             $dataMain | Add-Member -MemberType NoteProperty -Name "SkillProcessWooding" -Value $skillProcessWoodingId 
    #             "伐木训练过程制作完成。 SkillProcessWoodingId Id: $skillProcessWoodingId`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
    #             break;   
    #         }
    #     } 
    # }
    # catch {
    #     "伐木训练过程失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
    #     "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    #     Set-Location $startLocation 
    #     return    
    # }
    # if ($null -eq $skillProcessWoodingId) {
    #     "SkillProcessWoodingId Id 没有值，一定发生了什么。 `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
    #     Set-Location $startLocation 
    #     return    
    # }

    "伐木开始前，先看一下Player当前拥有的资源：" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White
    $payerWoodingResouceQuantityBeforeStart = 0
    $playerLogsQuantityBeforeStart = 0
    try {
        $result = sui client object $playId --json
        if (-not ('System.Object[]' -eq $result.GetType())) {
            "获取Player信息: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            Set-Location $startLocation
            return
        }
        $resultObj = $result | ConvertFrom-Json   
        #"Player 手上有如下资源：" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White
        foreach ($object in $resultObj.content.fields.inventory) {
            if ($($object.fields.item_id -eq $itemData.ResourceTypeWoodcutting.ItemId)) {
                $payerWoodingResouceQuantityBeforeStart = $($object.fields.quantity)
                "Item Id: $($object.fields.item_id) ,数量:$($object.fields.quantity), $($itemData.ResourceTypeWoodcutting.ChineseName)[$($itemData.ResourceTypeWoodcutting.Name)]" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow
            }
            elseif ($($object.fields.item_id -eq $itemData.ItemNormalLogs.ItemId)) {
                $playerLogsQuantityBeforeStart = $($object.fields.quantity)
                "Item Id: $($object.fields.item_id) ,数量:$($object.fields.quantity), $($itemData.ItemNormalLogs.ChineseName)[$($itemData.ItemNormalLogs.Name)]" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Green
            }
            else {
                "Item Id: $($object.fields.item_id) ,数量:$($object.fields.quantity)" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White
            }
        } 
    }
    catch {
        "获取Player信息失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
        Set-Location $startLocation 
        return    
    }

    $batchSize = 1
    "`n伐木开始..." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    try {
        $result = sui client call --package $mainPackageId --module skill_process_service --function start_creation --args $SkillProcessWoodingId $batchSize $playId $itemCreationWoodingId $clock $energyId --gas-budget 11000000 --json
        if (-not ('System.Object[]' -eq $result.GetType())) {
            "开始伐木时返回信息: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            Set-Location $startLocation
            return
        }
        $resultObj = $result | ConvertFrom-Json    
        "伐木已经开始..." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    }
    catch {
        "伐木失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
        Set-Location $startLocation 
        return    
    }


    "伐木开始后，再看一下Player当前拥有的资源：" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White
    $payerWoodingResouceQuantityAfterStart = 0
    $playerLogsQuantityAfterStart = 0
    try {
        $result = sui client object $playId --json
        if (-not ('System.Object[]' -eq $result.GetType())) {
            "获取Player信息: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            Set-Location $startLocation
            return
        }
        $resultObj = $result | ConvertFrom-Json   
        #"Player 手上有如下资源：" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White
        foreach ($object in $resultObj.content.fields.inventory) {
            if ($($object.fields.item_id -eq $itemData.ResourceTypeWoodcutting.ItemId)) {
                $payerWoodingResouceQuantityAfterStart = $($object.fields.quantity)
                "Item Id: $($object.fields.item_id) ,数量:$($object.fields.quantity), $($itemData.ResourceTypeWoodcutting.ChineseName)[$($itemData.ResourceTypeWoodcutting.Name)]，" +
                "可以看到数量减少了: " + ($payerWoodingResouceQuantityBeforeStart - $payerWoodingResouceQuantityAfterStart ) |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow
            }
            elseif ($($object.fields.item_id -eq $itemData.ItemNormalLogs.ItemId)) {
                $playerLogsQuantityAfterStart = $($object.fields.quantity)
                "Item Id: $($object.fields.item_id) ,数量:$($object.fields.quantity), $($itemData.ItemNormalLogs.ChineseName)[$($itemData.ItemNormalLogs.Name)]" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Green
            }
            else {
                "Item Id: $($object.fields.item_id) ,数量:$($object.fields.quantity)" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White
            }
        } 
    }
    catch {
        "获取Player信息失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
        Set-Location $startLocation 
        return    
    }

    "`n伐木中...需要等待$woodcuttingTime 秒钟..." | Write-Host
    Start-Sleep -Seconds ($woodcuttingTime * $batchSize)
    "该收工了...· `n" | Write-Host


    "`n来，现在结束伐木..." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    try {
        $result = sui client call --package $mainPackageId --module skill_process_aggregate --function complete_creation --args $skillProcessWoodingId $playId $itemCreationWoodingId $experienceTableId $clock --gas-budget 42000000 --json
        if (-not ('System.Object[]' -eq $result.GetType())) {
            "结束伐木流程返回信息: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            Set-Location $startLocation
            return
        }
        $resultObj = $result | ConvertFrom-Json    
        "伐木流程已经结束。" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    }
    catch {
        "结束伐木流程失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
        Set-Location $startLocation 
        return    
    }


    "伐木结束后，再来看一下Player当前拥有的资源：" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White
    $payerWoodingResouceQuantityAfterFinish = 0
    $playerLogsQuantityAfterFinish = 0
    try {
        $result = sui client object $playId --json
        if (-not ('System.Object[]' -eq $result.GetType())) {
            "获取Player信息: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            Set-Location $startLocation
            return
        }
        $resultObj = $result | ConvertFrom-Json   
        foreach ($object in $resultObj.content.fields.inventory) {
            if ($($object.fields.item_id -eq $itemData.ResourceTypeWoodcutting.ItemId)) {
                $payerWoodingResouceQuantityAfterFinish = $($object.fields.quantity)
                "Item Id: $($object.fields.item_id) ,数量:$($object.fields.quantity), $($itemData.ResourceTypeWoodcutting.ChineseName)[$($itemData.ResourceTypeWoodcutting.Name)]" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow
            }
            elseif ($($object.fields.item_id -eq $itemData.ItemNormalLogs.ItemId)) {
                $playerLogsQuantityAfterFinish = $($object.fields.quantity)
                "Item Id: $($object.fields.item_id) ,数量:$($object.fields.quantity), $($itemData.ItemNormalLogs.ChineseName)[$($itemData.ItemNormalLogs.Name)]，" + 
                "可以看到数量增加了: " + ($playerLogsQuantityAfterFinish - $playerLogsQuantityBeforeStart) |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Green
            
            }
            else {
                "Item Id: $($object.fields.item_id) ,数量:$($object.fields.quantity)" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White
            }
        } 
    }
    catch {
        "获取Player信息失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
        Set-Location $startLocation 
        return    
    }
}

$itemProductionCraftingId = $null
#造船一次耗费的时间（秒）
$craftingTime = 3
$crafingResourceIds = @()
$crafingResourceQuantities = @()
"`n搞一个造船配方 Item Production..." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
"需要以下基础资源：" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
foreach ($resouce in $itemData.CraftingResources) {
    "       $($resouce.ItemId) ->数量 $($resouce.Quantity)"  | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    $crafingResourceIds += $resouce.ItemId
    $crafingResourceQuantities += ($resouce.Quantity)
}
$crafingResourceIds_ = "[" + ($crafingResourceIds -join ",") + "]"
$crafingResourceQuantities_ = "[" + ($crafingResourceQuantities -join ",") + "]"

try {
    $result = sui client call --package $commonPackageId --module item_production_aggregate --function create --args  $crafting  $($itemData.ItemShip.ItemId)  $commonPublisherId $crafingResourceIds_ $crafingResourceQuantities_ 1 1 25 $craftingTime 10 100 $ItemProductionTableId --gas-budget 42000000 --json
    if (-not ('System.Object[]' -eq $result.GetType())) {
        "制作造船配方返回信息: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $resultObj = $result | ConvertFrom-Json   
    foreach ($object in $resultObj.objectChanges) {
        if ($object.objectType -like "*::item_production::ItemProduction") {
            $itemProductionCraftingId = $object.objectId
            $dataCommon | Add-Member -MemberType NoteProperty -Name "ItemProductionCrafting" -Value $itemProductionCraftingId 
            "造船配方制作完成。 ItemProductionCraftingId: $itemProductionCraftingId`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
            break;   
        }
    } 
}
catch {
    "制作造船配方失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
    "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation 
    return    
}
if ($null -eq $itemProductionCraftingId) {
    "ItemProductionCraftingId 没有值，一定发生了什么。 `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
    Set-Location $startLocation 
    return    
}

# $skillProcessCraftingId = ""
# "`n接着创建一个造船流程(crafting)" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
# try {
#     $result = sui client call --package $mainPackageId --module skill_process_aggregate --function create --args $crafting $playId '0' $playId $skillProcessTableId --gas-budget 24000000 --json
#     if (-not ('System.Object[]' -eq $result.GetType())) {
#         "创建生产流程(crafting)返回信息: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
#         Set-Location $startLocation
#         return
#     }
#     $resultObj = $result | ConvertFrom-Json
#     foreach ($object in $resultObj.objectChanges) {
#         if ($object.objectType -like "*skill_process::SkillProcess") {
#             $skillProcessCraftingId = $object.objectId
#             $dataMain | Add-Member -MemberType NoteProperty -Name "SkillProcessCrafting" -Value $skillProcessCraftingId 
#             "创建成功,SkillProcess Id: $skillProcessCraftingId`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
#             break;   
#         }
#     }
# }
# catch {
#     "创建生产流程(crafting)失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
#     "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
#     Set-Location $startLocation 
#     return    
# }
# if ($skillProcessCraftingId -eq "") {
#     "虽然执行了创建生产流程(crafting)的接口，但是没有获取 SkillProcess Id，所以请检查原因。" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
#     Set-Location $startLocation 
#     return    
# }


$dataJson | ConvertTo-Json | Set-Content -Path $dataFile 
Set-Location $startLocation 