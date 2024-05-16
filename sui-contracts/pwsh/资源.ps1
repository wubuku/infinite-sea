
$itemData = New-Object -TypeName PSObject


$ItemUnused = [PSCustomObject]@{
    ItemId                = 0
    Name                  = "UNUSED_ITEM"
    ChineseName           = "未使用"
    RequiredForCompletion = "false"
    SellsFor              = 1
    Quantity              = 0
}

$itemData | Add-Member -MemberType NoteProperty -Name "ItemUnused" -Value $ItemUnused

$ItemPotatoSeeds = [PSCustomObject]@{
    ItemId                = 1
    Name                  = "PotatoSeeds"
    ChineseName           = "土豆种子"
    RequiredForCompletion = "false"
    SellsFor              = 1
    Quantity              = 0
}


$itemData | Add-Member -MemberType NoteProperty -Name "ItemPotatoSeeds" -Value $ItemPotatoSeeds

$ItemPotatoes = [PSCustomObject]@{
    ItemId                = 101
    Name                  = "Potatoes"
    ChineseName           = "土豆"
    RequiredForCompletion = "true"
    SellsFor              = 1
    Quantity              = 0
}
$itemData | Add-Member -MemberType NoteProperty -Name "ItemPotatoes" -Value $ItemPotatoes

$ItemCottonSeeds = [PSCustomObject]@{
    ItemId                = 2
    Name                  = "CottonSeeds"
    ChineseName           = "棉花种子"
    RequiredForCompletion = "true"
    SellsFor              = 5
    Quantity              = 200
}
$itemData | Add-Member -MemberType NoteProperty -Name "ItemCottonSeeds" -Value $ItemCottonSeeds
$ItemCottons = [PSCustomObject]@{
    ItemId                = 102
    Name                  = "Cottons"
    ChineseName           = "棉花"
    RequiredForCompletion = "true"
    SellsFor              = 1
    Quantity              = 100
}
$itemData | Add-Member -MemberType NoteProperty -Name "ItemCottons" -Value $ItemCottons
$ItemBronzeBar = [PSCustomObject]@{
    ItemId                = 1001
    Name                  = "BronzeBar"
    ChineseName           = "铜条"
    RequiredForCompletion = "true"
    SellsFor              = 1
    Quantity              = 0
}
$itemData | Add-Member -MemberType NoteProperty -Name "ItemBronzeBar" -Value $ItemBronzeBar

$ItemNormalLogs = [PSCustomObject]@{
    ItemId                = 200
    Name                  = "NormalLogs"
    ChineseName           = "木头"
    RequiredForCompletion = "true"
    SellsFor              = 1
    Quantity              = 100
}
$itemData | Add-Member -MemberType NoteProperty -Name "ItemNormalLogs" -Value $ItemNormalLogs

$ItemShip = [PSCustomObject]@{
    ItemId                = 1000000001
    Name                  = "Ship"
    ChineseName           = "船"
    RequiredForCompletion = "true"
    SellsFor              = 1
    Quantity              = 0
}
$itemData | Add-Member -MemberType NoteProperty -Name "ItemShip" -Value $ItemShip

$ItemCopperOre = [PSCustomObject]@{
    ItemId                = 301
    Name                  = "CopperOre"
    ChineseName           = "铜"
    RequiredForCompletion = "true"
    SellsFor              = 1
    Quantity              = 100
}
$itemData | Add-Member -MemberType NoteProperty -Name "ItemCopperOre" -Value $ItemCopperOre

$ItemTinOre = [PSCustomObject]@{
    ItemId                = 302
    Name                  = "TinOre"
    ChineseName           = "锡"
    RequiredForCompletion = "true"
    SellsFor              = 1
    Quantity              = 0
}
$itemData | Add-Member -MemberType NoteProperty -Name "ItemTinOre" -Value $ItemTinOre

$ResourceTypeWoodcutting = [PSCustomObject]@{
    ItemId                = 2000000001
    Name                  = "ResourceTypeWoodcutting"
    ChineseName           = "伐木资源"
    RequiredForCompletion = "true"
    SellsFor              = 1
    Quantity              = 200
}
$itemData | Add-Member -MemberType NoteProperty -Name "ResourceTypeWoodcutting" -Value $ResourceTypeWoodcutting

$ResourceTypeFishing = [PSCustomObject]@{
    ItemId                = 2000000002
    Name                  = "ResourceTypeFishing"
    ChineseName           = "捕鱼资源"
    RequiredForCompletion = "true"
    SellsFor              = 1
    Quantity              = 0
}
$itemData | Add-Member -MemberType NoteProperty -Name "ResourceTypeFishing" -Value $ResourceTypeFishing

$ResourceTypeMining = [PSCustomObject]@{
    ItemId                = 2000000003
    Name                  = "ResourceTypeMining"
    ChineseName           = "挖矿资源"
    RequiredForCompletion = "true"
    SellsFor              = 1
    Quantity              = 200
}
$itemData | Add-Member -MemberType NoteProperty -Name "ResourceTypeMining" -Value $ResourceTypeMining

#造船所需最少原材料
$CraftingResources = @(
    [PSCustomObject]@{
        ItemId   = $ItemCottons.ItemId
        Name     = $ItemCottons.Name
        Quantity = 3
    },
    [PSCustomObject]@{
        ItemId   = $ItemNormalLogs.ItemId
        Name     = $ItemNormalLogs.Name
        Quantity = 3
    },
    [PSCustomObject]@{
        ItemId   = $ItemCopperOre.ItemId
        Name     = $ItemCopperOre.Name
        Quantity = 3
    }
)
$itemData | Add-Member -MemberType NoteProperty -Name "CraftingResources" -Value $CraftingResources



$itemDataFile = ".\item.json"
$itemData | ConvertTo-Json | Set-Content -Path $itemDataFile 


# $ComeFromFile = Get-Content -Raw -Path $itemDataFile
# $ComeFromFileObj = $ComeFromFile | ConvertFrom-Json

# $ComeFromFileObj | Write-Host
