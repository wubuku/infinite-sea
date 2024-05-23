$startLocation = Get-Location; 

$now = Get-Date
$formattedNow = $now.ToString('yyyyMMddHHmmss')
$logFile = "$startLocation\ShipToShip.log"

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
$shipFromId = "0x273bd00b0df174f6595fcd5f6e8dbe8344a38a5f6aa4516e0002b49def8c39c4"
$shipToId = "0xdf17c004d47be86384895044a4df3325928a82706733e7a1562ab3ecd46957cf"

$rosterInfoResult = ""
try {
    $rosterInfoResult = sui client object $roster --json 
    if (-not ('System.Object[]' -eq $rosterInfoResult.GetType())) {
        "获取船队 $roster 信息时返回: $rosterInfoResult" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $rosterObj = $rosterInfoResult | ConvertFrom-Json
    if (-not $rosterObj.content.fields.ship_ids.Contains($shipFromId)) {
        "船队 $roster 内不包括船只 $shipFromId"  | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    if (-not $rosterObj.content.fields.ship_ids.Contains($shipToId)) {
        "船队 $roster 内不包括船只 $shipToId"  | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
}
catch {
    "获取船队 $roster 信息失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
    "返回的结果为:$rosterInfoResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation
    return    
}

"将船只 $shipFromId 上的部分资源转移到船只 $shipToId 上。"  | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Green

$BeforeTransferShipFrom = @{}
$BeforeTransferShipTo = @{}
$change = @{}

"`n转移之前,看一下船只 $shipFromId 当前拥有的资源：" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow
try {
    $shipResult = sui client object $shipFromId --json 
    if (-not ('System.Object[]' -eq $shipResult.GetType())) {
        "查询船只 $shipFromId 时返回信息： $shipResult" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $shipFromObj = $shipResult | ConvertFrom-Json
    if ($shipFromObj.content.fields.inventory.Length -eq 0) {
        "船只 $shipFromId 没有任何资源。" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
        Set-Location $startLocation
        return
    }
    foreach ($object in $shipFromObj.content.fields.inventory) {
        "Item Id: $($object.fields.item_id),数量:$($object.fields.quantity)" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White
        $BeforeTransferShipFrom.Add($object.fields.item_id, $object.fields.quantity)
    }
}
catch {
    "查询船只 $shipFromId 信息失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
    "返回的结果为:$shipResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation
    return    
}
"船只 $shipToId 有以下资源：" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow  
try {
    $shipResult = sui client object $shipToId --json 
    if (-not ('System.Object[]' -eq $shipResult.GetType())) {
        "查询船只 $shipToId 时返回信息： $shipResult" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $shipToObj = $shipResult | ConvertFrom-Json
    if ($shipToObj.content.fields.inventory.Length -eq 0) {
        "船只 $shipFromId 没有任何资源。" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
    }
    foreach ($object in $shipToObj.content.fields.inventory) {
        "Item Id: $($object.fields.item_id),数量:$($object.fields.quantity)" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White
        $BeforeTransferShipTo.Add($object.fields.item_id, $object.fields.quantity)
    }
}
catch {
    "查询船只 $shipToId 信息失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
    "返回的结果为:$shipResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation
    return    
} 

$islandResourceIds = @()
$islandResourceQuantities = @()
"`n把以下资源从船只 $shipFromId 转移到 船只 $shipToId 上：" | Tee-Object -FilePath $logFile -Append  |  Write-Host  -ForegroundColor Yellow
$random = New-Object System.Random  
foreach ($resouce in $shipFromObj.content.fields.inventory.fields) {      
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
    $command = "sui client call --package $($dataInfo.main.PackageId)  --module roster_aggregate --function transfer_ship_inventory --args $roster $($dataInfo.main.Player) $shipFromId $shipToId $islandResources_  $islandResourceQuantities_ --gas-budget 11000000 --json" 
    $command | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
    $putInShipInventoryResult = Invoke-Expression -Command $command
    if (-not ('System.Object[]' -eq $putInShipInventoryResult.GetType())) {
        "转移返回信息： $putInShipInventoryResult" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $transferResultObj = $putInShipInventoryResult | ConvertFrom-Json
    "转移完成。`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
}
catch {
    "资源转移失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
    "返回的结果为:$putInShipInventoryResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation
    return    
}    

"转移之后，再看一下船只 $shipFromId 当前拥有的资源：" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow 
try {
    $shipResult = sui client object $shipFromId --json 
    if (-not ('System.Object[]' -eq $shipResult.GetType())) {
        "查询船只 $shipFromId 时返回信息： $shipResult" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $shipObj = $shipResult | ConvertFrom-Json
    foreach ($object in $shipObj.content.fields.inventory) {
        $itemId = $object.fields.item_id
        $quantityBefore = $BeforeTransferShipFrom[$itemId]
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
    "查询船只 $shipFromId 信息失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
    "返回的结果为:$shipResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation
    return    
}
"而船只 $shipToId 有以下资源：" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow  
try {
    $shipResult = sui client object $shipToId --json 
    if (-not ('System.Object[]' -eq $shipResult.GetType())) {
        "查询船只 $shipToId 时返回信息： $shipResult" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $shipObj = $shipResult | ConvertFrom-Json
    foreach ($object in $shipObj.content.fields.inventory) {
        $itemId = $object.fields.item_id
        $quantityBefore = ($null -eq $BeforeTransferShipTo[$itemId])?0:$BeforeTransferShipTo[$itemId]
        $quantityChange = $change[$itemId]
        $quantityAfter = $object.fields.quantity
        "Item Id($itemId),原有数量:$quantityBefore,增加数量:$quantityChange,当前数量:$quantityAfter，" |  Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor White -NoNewline
        if ($quantityBefore + $quantityChange -eq $quantityAfter) {
            "($quantityBefore + $quantityChange = $quantityAfter) OK"  | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Green
        }
        else {
            "($quantityBefore + $quantityChange ≠ $quantityAfter) NO"  | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        }
    }
}
catch {
    "查询船只 $shipToId 信息失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
    "返回的结果为:$shipResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation
    return    
}
Set-Location $startLocation

