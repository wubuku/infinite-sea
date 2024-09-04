$startLocation = Get-Location; 

$now = Get-Date
$formattedNow = $now.ToString('yyyyMMddHHmmss')
$logFile = "$startLocation\set_sail_$formattedNow.log"

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


#用那个船队去挑战？数字x表示编号为x的船队，例如$rosters.2表示玩家编号为2的船队，可取值范围为1-4
$rosterId = $rosters.2
"RosterId: $rosterId" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
$currentCoordinates = $null
$speed = 1
$shipIds = @()
$set_sail_at = 0
$coordinates_updated_at = 0

try {
    $getRosterResult = sui client object $rosterId --json 
    if (-not ('System.Object[]' -eq $getRosterResult.GetType())) {
        "获取Roster $rosterId 信息时返回 $getRosterResult" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $getRosterResultObj = $getRosterResult | ConvertFrom-Json
    "船队编号： $($getRosterResultObj.content.fields.roster_id.fields.sequence_number) " | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
    $rosterCurrentShipCount = $getRosterResultObj.content.fields.ships.fields.size
    "目前拥有船只数量：$rosterCurrentShipCount 只。" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
    $shipIds = $getRosterResultObj.content.fields.ship_ids
    if ($shipIds.Count -gt 0) {
        "分别为：" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Gray
        foreach ($shipId in $shipIds) {
            "   $shipId" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor White
        }
    }
    "所属Player: $($getRosterResultObj.content.fields.roster_id.fields.player_id)" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
    "当前位置： $($getRosterResultObj.content.fields.updated_coordinates.fields)" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor White
    $currentCoordinates = $getRosterResultObj.content.fields.updated_coordinates.fields;
    $targetCoordinates = $getRosterResultObj.content.fields.target_coordinates
    $coordinates_updated_at = $getRosterResultObj.content.fields.coordinates_updated_at
    $set_sail_at = $getRosterResultObj.content.fields.set_sail_at
    if ($null -ne $targetCoordinates) {
        "目的地： $($targetCoordinates.fields)" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor White
    }
    else { Write-Host "     没有设置目的地" }
    $status = $getRosterResultObj.content.fields.status
    $speed = $getRosterResultObj.content.fields.speed
    "船队速度: $speed " | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor White
    "船队状态值(status): $status ，表示：" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor White
    if ($status -eq 0) {
        "   停泊中(at_anchor)" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
    }
    elseif ($status -eq 1) {
        "    行进中(underway)" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
    }
    elseif ($status -eq 2) {
        "    战斗中(in_battle)" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
    }
    elseif ($status -eq 3) {
        "    已损毁(destroyed)" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
    }
    else {
        "    不明(unvalid)" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
    }
}
catch {
    "获取Roster $rosterId 信息失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
    "返回的结果为:$getRosterResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    return    
}  

#目标坐标的来源有三种
#1、直接指定 $targetCoordinates
#2、指定目标船队的Id(targetRosterId)
#3、来在于配置文件 environment_roster.json 

$targetRosterId = "0xc858c3711f76652b7c6ee2342c06f35fb20c3578991f9d0ac9e382e846bab599"
#先查看一下目标船队的坐标
$targetCoordinates = $null
# $targetCoordinates = [PSCustomObject]@{
#     x = 2147486306
#     y = 2147478169
# }
$updated_coordinates_x = 0
$updated_coordinates_y = 0
$environmentRosterResult = ""
if ($null -ne $targetCoordinates) {    
    "目的地坐标来源:指定了具体坐标" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Blue
}
else {
    "因为没有明确指明目的地坐标,所以目的地可能来自指定的目标船队 Id,或者 environment_roster.json 中指定的环境船队的Id " | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Yellow
    if ($null -eq $targetRosterId -or $targetRosterId -eq "") {
        $environmentRosterJsonFile = "$startLocation\environment_roster.json"
        if (-not (Test-Path -Path $environmentRosterJsonFile -PathType Leaf)) {
            "环境船队信息文件 $playerRostersFile 不存在 " | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Red
            return
        }
        $environmentRosterJson = Get-Content -Raw -Path $environmentRosterJsonFile
        $environmentRoster = $environmentRosterJson | ConvertFrom-Json
        $targetRosterId = $environmentRoster.RosterId
        "目的地坐标来源: environment_roster.json 文件" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Blue
    }
    else {
        "目的地坐标来源:指定的目标船队Id" | Tee-Object -FilePath $logFile -Append  | Write-Host  -ForegroundColor Blue
    }
    try {
        $environmentRosterResult = sui client object $targetRosterId --json 
        if (-not ('System.Object[]' -eq $environmentRosterResult.GetType())) {
            "获取目标船队 $targetRosterId 信息时返回: $environmentRosterResult" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
            return
        }
        $environmentRosterObj = $environmentRosterResult | ConvertFrom-Json
        $targetCoordinates = $environmentRosterObj.content.fields.updated_coordinates.fields
        "`n将要攻击的目标船队当前坐标：($($targetCoordinates.x),$($targetCoordinates.y))" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
    }
    catch {
        "获取目标船队 $targetRosterId 信息失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
        "返回的结果为:$environmentRosterResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
        return    
    }
    if ($null -eq $environmentRosterResult) {    
        "没能获取目标船队当前坐标，请先检查一下。" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
    }
}
if ($null -eq $targetCoordinates) {
    "必须指定目的地坐标" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
    return
}

#函数：获取两个坐标之间的直线距离
function Get-Distance {
    param (
        [Parameter(Mandatory = $true)]
        [double]$x1,
        [Parameter(Mandatory = $true)]
        [double]$y1,
        [Parameter(Mandatory = $true)]
        [double]$x2,
        [Parameter(Mandatory = $true)]
        [double]$y2
    )

    $distance = [Math]::Sqrt(([Math]::Pow($x2 - $x1, 2) + [Math]::Pow($y2 - $y1, 2)))
    [long]$result = [long]$distance
    return $result
}

function SpeedPropertyToCoordinateUnitsPerSecond {
    #逻辑来自module infinite_sea_common::speed_util
    param (
        [uint32]$speed_property
    )
    $STANDARD_SPEED_NUMERATOR = 11784  
    $STANDARD_SPEED_DENOMINATOR = 1000    
    $SPEED_NUMERATOR_DELTA = 1178       

    $numerator = $STANDARD_SPEED_NUMERATOR
    $denominator = $STANDARD_SPEED_DENOMINATOR

    if ($speed_property -lt 5) {
        $numerator = $numerator - ($SPEED_NUMERATOR_DELTA * (5 - $speed_property))
    }
    else {
        $numerator = $numerator + ($SPEED_NUMERATOR_DELTA * ($speed_property - 5))
    }

    return @($numerator, $denominator)
}

$distance = Get-Distance -x1 $currentCoordinates.x -y1 $currentCoordinates.y -x2 $targetCoordinates.x -y2 $targetCoordinates.y
"船队当前与目标的距离为 $distance" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow

$ENERGY_AMOUNT_PER_SECOND_PER_SHIP = 1388889 #来自 module infinite_sea::roster_set_sail_logic

$speedX = SpeedPropertyToCoordinateUnitsPerSecond -speed_property $speed

$sail_duration = [math]::Ceiling($distance * $speedX[1] / $speedX[0])

$energy_amount = $sail_duration * $ENERGY_AMOUNT_PER_SECOND_PER_SHIP * $shipIds.Count

"走直线所需要的最短时间: $sail_duration 秒，需要消耗ENERGY: $energy_amount" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow

# 定义 Unix 纪元时间（1970年1月1日）
$epoch = Get-Date "1970-01-01T00:00:00Z"

# 计算自 Unix 纪元以来的总秒数
$secondsSinceEpoch = [math]::Floor((New-TimeSpan -Start $epoch -End $now).TotalSeconds)

# 输出结果
"船队从出发到现在经过了: $($secondsSinceEpoch-$set_sail_at) 秒，距离上一次更新位置经过了 $($secondsSinceEpoch-$coordinates_updated_at) 秒" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow



return

#将 updated_coordinates_x 和 updated_coordinates_y 设置的离目标船队很近，节省时间
# $updated_coordinates_x = $targetCoordinates.x - 50
# $updated_coordinates_y = $targetCoordinates.y - 50
try {
    "`n准备出发，目标坐标：($($targetCoordinates.x),$($targetCoordinates.y))。" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
    $command = "sui client call --package $($dataInfo.main.PackageId)  --module roster_service --function set_sail --args $rosterId $($dataInfo.main.Player) $($targetCoordinates.x) $($targetCoordinates.y) '0x6' $($dataInfo.coin.EnergyId) $energy_amount $sail_duration $updated_coordinates_x $updated_coordinates_y --gas-budget 11000000 --json" 
    $command | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
    $setSailResult = Invoke-Expression -Command $command
    if (-not ('System.Object[]' -eq $setSailResult.GetType())) {
        "船队启航返回信息： $setSailResult" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
        Set-Location $startLocation
        return
    }
    $setSailResultObj = $setSailResult | ConvertFrom-Json
    "船队已经启航，等到达目的地，将发生战斗。`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
}
catch {
    "船队启航失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
    "返回的结果为:$setSailResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    Set-Location $startLocation
    return    
}

Set-Location $startLocation

