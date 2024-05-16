
$startLocation = Get-Location; 

$dataFile = ".\data.json"
if (-not (Test-Path -Path $dataFile -PathType Leaf)) {
    "文件 $dataFile 不存在 " | Write-Host  -ForegroundColor Red
    return
}
$ComeFromFile = Get-Content -Raw -Path $dataFile
$dataInfo = $ComeFromFile | ConvertFrom-Json

$claimFile = "$startLocation\claim_island.json"
if (-not (Test-Path -Path $claimFile -PathType Leaf)) {
    "文件 $dataFile 不存在 " | Write-Host  -ForegroundColor Red
    return
}
$ClaimInRaw = Get-Content -Raw -Path $claimFile
$ClaimInfo = $ClaimInRaw | ConvertFrom-Json

$RosterData = New-Object -TypeName PSObject
$RosterIds = @()
foreach ($Roster in $ClaimInfo.objectChanges) {
    if ($Roster.objectType -like "*::roster::Roster") {
        $RosterIds += $Roster.objectId
        try {
            $result = sui client object $Roster.objectId --json 
            if (-not ('System.Object[]' -eq $result.GetType())) {
                "获取Roster $Roster.objectId 信息时返回 $result" | Write-Host  -ForegroundColor Red
                Set-Location $startLocation
                return
            }
            $resutJson = $result | ConvertFrom-Json
            #$resutJson.content.fields.roster_id.fields.sequence_number | Write-Host -ForegroundColor Green
            $RosterData | Add-Member -MemberType NoteProperty -Name $resutJson.content.fields.roster_id.fields.sequence_number -Value $Roster.objectId
        }
        catch {
            "获取Roster $Roster.objectId 信息失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
            Set-Location $startLocation
            return    
        }
    }
}

$playerRostersFile = "$startLocation\rosters.json"
$RosterData | ConvertTo-Json | Tee-Object -FilePath $playerRostersFile | Write-Host -ForegroundColor Green

"相关数据请参考: $playerRostersFile" | Write-Host -ForegroundColor Blue


Set-Location $startLocation
