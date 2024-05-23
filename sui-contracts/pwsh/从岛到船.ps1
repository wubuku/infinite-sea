$startLocation = Get-Location; 

$now = Get-Date
$formattedNow = $now.ToString('yyyyMMddHHmmss')
$logFile = "$startLocation\islandToShip.log"

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


$roster = $rosters.4
$shipId = "0x273bd00b0df174f6595fcd5f6e8dbe8344a38a5f6aa4516e0002b49def8c39c4"

$rosterInfoResult = ""
try {
    $rosterInfoResult = sui client object $roster --json 
    if (-not ('System.Object[]' -eq $rosterInfoResult.GetType())) {
        "获取船队 $roster 信息时返回: $rosterInfoResult" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $rosterObj = $rosterInfoResult | ConvertFrom-Json
    if (-not $rosterObj.content.fields.ship_ids.Contains($shipId)) {
        "船队 $roster 内不包括船只 $shipId。"  | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
    }
}
catch {
    "获取船队 $roster 信息失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
    "返回的结果为:$rosterInfoResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation
    return    
}

"将资源中的资源转移到船队 $roster 的船只 $shipId 上。"  | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Green


$BeforePutInPlayer = @{}
$BeforePutInShip = @{}
$change = @{}
$AfterPutInShip = @{}
"转移之前，看一下Player当前拥有的资源：" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow
try {
    $result = sui client object $dataInfo.main.Player --json
    if (-not ('System.Object[]' -eq $result.GetType())) {
        "获取Player信息: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $resultObj = $result | ConvertFrom-Json   
    foreach ($object in $resultObj.content.fields.inventory) {
        "Item Id: $($object.fields.item_id),数量:$($object.fields.quantity)" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White
        $BeforePutInPlayer.Add($object.fields.item_id, $object.fields.quantity)
    } 
}
catch {
    "获取Player信息失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
    "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation 
    return    
}

"当前船上有以下资源：" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow  
try {
    $shipResult = sui client object $shipId --json 
    if (-not ('System.Object[]' -eq $shipResult.GetType())) {
        "查询船只 $shipId 时返回信息： $shipResult" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $shipObj = $shipResult | ConvertFrom-Json
    foreach ($object in $shipObj.content.fields.inventory) {
        "Item Id: $($object.fields.item_id),数量:$($object.fields.quantity)" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White
        $BeforePutInShip.Add($object.fields.item_id, $object.fields.quantity)
    }
}
catch {
    "查询船只 $shipId 信息失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
    "返回的结果为:$shipResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation
    return    
}

$islandResourceIds = @()
$islandResourceQuantities = @()
"`n从岛屿转移以下资源到指定船队的船只上：" | Tee-Object -FilePath $logFile -Append  |  Write-Host  
$random = New-Object System.Random  
foreach ($resouce in $resultObj.content.fields.inventory.fields) {      
    $quantity = $random.Next(0, $resouce.Quantity)  
    "Item Id:$($resouce.item_id),数量:$quantity"  | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    $islandResourceIds += $resouce.item_id
    $islandResourceQuantities += $quantity
    $change.Add($resouce.item_id, $quantity)
}
$islandResources_ = "[" + ($islandResourceIds -join ",") + "]"
$islandResourceQuantities_ = "[" + ($islandResourceQuantities -join ",") + "]"

try {
    "`n执行资源转移。。。" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
    $command = "sui client call --package $($dataInfo.main.PackageId)  --module roster_aggregate --function put_in_ship_inventory --args $roster $($dataInfo.main.Player) '0x6' $shipId $islandResources_  $islandResourceQuantities_ --gas-budget 11000000 --json" 
    $command | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
    $putInShipInventoryResult = Invoke-Expression -Command $command
    if (-not ('System.Object[]' -eq $putInShipInventoryResult.GetType())) {
        "转移返回信息： $putInShipInventoryResult" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $setSailResultObj = $putInShipInventoryResult | ConvertFrom-Json
    "转移完成。`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
}
catch {
    "资源转移失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
    "返回的结果为:$putInShipInventoryResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation
    return    
}
    

"转移之后，再看一下Player 当前拥有的资源：" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White
try {
    $result = sui client object $dataInfo.main.Player --json
    if (-not ('System.Object[]' -eq $result.GetType())) {
        "获取Player信息: $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $resultObj = $result | ConvertFrom-Json  
    foreach ($object in $resultObj.content.fields.inventory) {
        $itemId = $object.fields.item_id
        $quantityBefore = $BeforePutInPlayer[$itemId]
        $quantityChange = $change[$itemId]
        $quantityAfter = $object.fields.quantity
        "Item Id($itemId),原有数量:$quantityBefore,减少数量:$quantityChange,当前数量:$quantityAfter，" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White -NoNewline
        if ($quantityBefore - $quantityChange -eq $quantityAfter) {
            "($quantityBefore - $quantityChange = $quantityAfter) OK"  | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Green
        }
        else {
            "($quantityBefore - $quantityChange ≠ $quantityAfter) NO"  | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        }
    } 
}
catch {
    "获取Player信息失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
    "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation 
    return    
}
"当前船上有以下资源：" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow  
try {
    $shipResult = sui client object $shipId --json 
    if (-not ('System.Object[]' -eq $shipResult.GetType())) {
        "查询船只 $shipId 时返回信息： $shipResult" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $shipObj = $shipResult | ConvertFrom-Json
    foreach ($object in $shipObj.content.fields.inventory) {
        $itemId = $object.fields.item_id
        $quantityBefore = $BeforePutInShip[$itemId]
        $quantityChange = $change[$itemId]
        $quantityAfter = $object.fields.quantity
        "Item Id($itemId),原有数量:$quantityBefore,减少增加:$quantityChange,当前数量:$quantityAfter，" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White -NoNewline
        if ($quantityBefore + $quantityChange -eq $quantityAfter) {
            "($quantityBefore - $quantityChange = $quantityAfter) OK"  | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Green
        }
        else {
            "($quantityBefore - $quantityChange ≠ $quantityAfter) NO"  | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        }
    }
}
catch {
    "查询船只 $shipId 信息失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
    "返回的结果为:$shipResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation
    return    
}

Set-Location $startLocation

