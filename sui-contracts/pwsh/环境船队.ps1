
$startLocation = Get-Location; 

$now = Get-Date
$formattedNow = $now.ToString('yyyyMMddHHmmss')
$logFile = "$startLocation\environment_roster.log"


$dataFile = ".\data.json"
if (-not (Test-Path -Path $dataFile -PathType Leaf)) {
    "文件 $dataFile 不存在 " | Write-Host  -ForegroundColor Red
    return
}
$ComeFromFile = Get-Content -Raw -Path $dataFile
$dataInfo = $ComeFromFile | ConvertFrom-Json

$u32MaxHalf = 2147483647
$coordinates_x = $u32MaxHalf + 7
$coordinates_y = $u32MaxHalf + 7

#环境Player，如果没有值需要新造一个Player
#$newPlayId = "0x10b96031518b27cb238f610dd67523d90015c0c29e612730b24fb54893cf2282"
$newPlayId = ""
$playName = 'ABC'
if ($null -eq $newPlayId -or $newPlayId -eq "") {
    "`n创建一个PLAYER..." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    $result = ""
    try {
        $result = sui client call --package $dataInfo.main.PackageId --module player_aggregate --function create --args $playName --gas-budget 11000000 --json
        if (-not ('System.Object[]' -eq $result.GetType())) {
            "创建Player时返回信息 $result" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            Set-Location $startLocation
            return
        }
        $resultObj = $result | ConvertFrom-Json
        foreach ($object in $resultObj.objectChanges) {
            if ($object.objectType -like "*player::Player") {
                $newPlayId = $object.objectId
                #$dataMain | Add-Member -MemberType NoteProperty -Name "Player" -Value $newPlayId 
                "创建成功,Player Id: $newPlayId`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
                break;   
            }
        }
    }
    catch {
        "创建Player失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
        "返回的结果为:$result" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
        Set-Location $startLocation
        return    
    }
}
if ($newPlayId -eq "") {    
    "Player Id 还是为空，请检查一下原因。" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Red
    Set-Location $startLocation
    return    
}

"休息一下，以免新生成的 Player 不能使用..." | Write-Host
Start-Sleep -Seconds 2
"休息完成，开始创建环境船队...· `n" | Write-Host

$roster_id_sequence_number = 1


$createEnvironmentRosterResult = ""
$ship_resource_quantity = 15
$ship_base_resource_quantity = 3
$base_experience = 10
$clock = '0x6'


$shipIds = @()
$rosterId = ""
$createEnvironmentRosterResult = ""
try {
    $command = "sui client call --package $($dataInfo.main.PackageId) --module roster_aggregate --function create_environment_roster --args  $newPlayId $roster_id_sequence_number $($dataInfo.main.Publisher) $coordinates_x $coordinates_y $ship_resource_quantity $ship_base_resource_quantity $base_experience $clock $($dataInfo.main.RosterTable) --gas-budget 42000000 --json"
    $command | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
    $createEnvironmentRosterResult = Invoke-Expression -Command $command
    if (-not ('System.Object[]' -eq $createEnvironmentRosterResult.GetType())) {
        "创建环境船队时返回信息 $createEnvironmentRosterResult" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $createEnvironmentRosterResultObj = $createEnvironmentRosterResult | ConvertFrom-Json
    foreach ($object in $createEnvironmentRosterResultObj.objectChanges) {
        if ($object.objectType -like "*::roster::Roster") {
            $rosterId = $object.objectId
            #$dataMain | Add-Member -MemberType NoteProperty -Name "Player" -Value $newPlayId 
            "创建环境船队成功， Roster Id: $rosterId`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
            #break;   
        }
        if ($object.objectType -like "*::ship::Ship") {
            $shipId = $object.objectId
            $shipIds += $shipId
            #$dataMain | Add-Member -MemberType NoteProperty -Name "Player" -Value $newPlayId 
        }
    }
}
catch {
    "创建环境船队失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
    "返回的结果为:$createEnvironmentRosterResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation
    return    
}

"该脚本执行后相关的日志请参考: $logFile" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Blue
#将结果保存到一个JSON文件中
$EnvironmentRosterJson = New-Object -TypeName PSObject
$EnvironmentRosterJson | Add-Member -MemberType NoteProperty -Name "PlayerId" -Value $newPlayId 
$EnvironmentRosterJson | Add-Member -MemberType NoteProperty -Name "RosterId" -Value $rosterId 
$EnvironmentRosterJson | Add-Member -MemberType NoteProperty -Name "ShipIds" -Value $shipIds 

$environmentRosterJsonFile = "$startLocation\environment_roster.json"
$EnvironmentRosterJson | ConvertTo-Json | Tee-Object -FilePath $environmentRosterJsonFile | Write-Host -ForegroundColor White

"相关数据请参考: $environmentRosterJsonFile" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Blue


Set-Location $startLocation