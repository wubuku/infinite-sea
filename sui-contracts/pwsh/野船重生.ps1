$startLocation = Get-Location; 

$environmentRosterJsonFile = "$startLocation\island_environment_roster.json"
$islandEnvironmentRosterInfo = $null
if (Test-Path -Path $environmentRosterJsonFile -PathType Leaf) {    
    $islandEnvironmentRosterInfoFileContent = Get-Content -Raw -Path $environmentRosterJsonFile
    $islandEnvironmentRosterInfo = $islandEnvironmentRosterInfoFileContent | ConvertFrom-Json
}
else {    
    $islandEnvironmentRosterInfo = New-Object -TypeName PSObject
    $islandEnvironmentRosterInfo | Add-Member -MemberType NoteProperty -Name "LastRosterIdSequenceNumber" -Value 0
}

$dataFile = ".\data.json"
if (-not (Test-Path -Path $dataFile -PathType Leaf)) {
    "文件 $dataFile 不存在 " | Write-Host  -ForegroundColor Red
    return
}
$ComeFromFile = Get-Content -Raw -Path $dataFile
$dataInfo = $ComeFromFile | ConvertFrom-Json


$now = Get-Date
$formattedNow = $now.ToString('yyyyMMddHHmmss')
$logFile = "$startLocation\environment_roster_rebirth_$formattedNow.log"

#链下服务相关配置
$serverUrl = "http://ec2-34-222-163-11.us-west-2.compute.amazonaws.com:8090"

# 目前岛屿所占海域大小
# $islandWidth = 10000
# $islandHeight = 10000
$islandWidth = 5000
$islandHeight = 5000
$u32MaxHalf = 2147483647
# 在岛屿周边查找环境船队，以岛屿的中心坐标为准做一个矩形，矩形的大小 $islandWidth*$range,$islandHeight*$range
#$range = 0.2
#改为距离岛屿中心点 1800-3000之间的矩形带
$innerDistince = 1800
$outerDistince = 3000

#每个岛屿有多少个环境船队
$environmentQuntityPerIsland = 3

#添加船队时，最大出错次数不能超过$maxErrorTimes
$maxErrorTimes = 5

$node = "https://fullnode.testnet.sui.io/"
$getMapResult = $null
$dynamicFiledsId = $null;
try {
    $getMapResult = sui client object $dataInfo.map.Map --json
    $map = $getMapResult | ConvertFrom-Json
    $dynamicFiledsId = $map.content.fields.locations.fields.id.id;
    $quntity = $map.content.fields.locations.fields.size;
    "从地图对象可以看到有 :$quntity 个岛屿..." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Blue
}
catch {
    "查询地图失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
    "返回的结果为:$getMapResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    return    
}
if ($null -eq $dynamicFiledsId) {
    "没有得到动态字段 Id。" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Red
    return;
}

$nextCursor = $null
$hasNextPage = $true
$limit = 50
$islandCoordinates = @()
while ($hasNextPage) {
    $command = ($null -eq $nextCursor)?
    'curl -X POST -H "Content-Type: application/json" -d ''{"jsonrpc":"2.0","id":1,"method":"suix_getDynamicFields","params":["' + $dynamicFiledsId + '",null,' + $limit + ']}'' ' + $node
    :'curl -X POST -H "Content-Type: application/json" -d ''{"jsonrpc":"2.0","id":1,"method":"suix_getDynamicFields","params":["' + $dynamicFiledsId + '","' + $nextCursor + '",' + $limit + ']}'' ' + $node
    $command | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    $result = Invoke-Expression -Command $command 
    $resultObj = $result | ConvertFrom-Json
    if ($null -ne $resultObj.error) {
        "suix_getDynamicFields error:" + $resultObj.error.message | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Red
        break;
    }
    foreach ($coordinate in $resultObj.result.data) {
        $islandCoordinates += $coordinate.name.value
        #"($($coordinate.name.value.x),$($coordinate.name.value.y))" |  Write-Host -ForegroundColor White 
        "($($coordinate.name.value.x-$u32MaxHalf),$($coordinate.name.value.y-$u32MaxHalf))" |  Write-Host -ForegroundColor White 
    }
    $hasNextPage = $resultObj.result.hasNextPage
    $nextCursor = $resultObj.result.nextCursor;
}
"一共得到了 $($islandCoordinates.Count) 个岛屿坐标。" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow

# 如果环境船队也从链上查找的话效率太低了，所以使用链下服务接口吧。


$getAllEnviornmentRostersResult = $null
$rosterCoordinates = @()
try {
    $getAllEnviornmentRostersUrl = $serverUrl + "/api/Rosters?environmentOwned=true&status=ne(3)"
    #按说应该使用 status=ne(3),但是powershell会报错所以先用status=0吧，毕竟野船队目前不动
    #$getAllEnviornmentRostersUrl = $serverUrl + "/api/Rosters?environmentOwned=true&status=0"
    $command = "curl -X GET '" + $getAllEnviornmentRostersUrl + "' -H 'accept: application/json'"
    # $getAllIslandResult = curl -X GET $getAllIslandUrl -H "accept: application/json"   
    $command | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
    $getAllEnviornmentRostersResult = Invoke-Expression -Command $command 
    $getAllEnviornmentRostersResultObj = $getAllEnviornmentRostersResult | ConvertFrom-Json
    "目前一共有 $($getAllEnviornmentRostersResultObj.Count) 个活着的环境船队..." | Tee-Object -FilePath $logFile -Append  |  Write-Host     
    foreach ($roster in $getAllEnviornmentRostersResultObj) {
        $rosterCoordinates += $roster.updatedCoordinates;
        #"coordinates:($($roster.updatedCoordinates.x),$($roster.updatedCoordinates.y))" |  Write-Host 
        "coordinates:($($roster.updatedCoordinates.x-$u32MaxHalf),$($roster.updatedCoordinates.y-$u32MaxHalf))" |  Write-Host 
    }
}
catch {
    "获取岛屿列表失败: $($_.Exception.Message)" | Write-Host -ForegroundColor Red
    "返回的结果为:$getAllEnviornmentRostersResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
    return    
}


"目前岛屿所占海域大小为:{$islandWidth,$islandHeight}" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
#"我们认为岛屿周边的环境船队不超过岛屿所占海域面积的$($range*100)%，也就是($($islandWidth*0.2),$($islandHeight*0.2))" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
"我们认为岛屿周边的环境船队分布在距离岛屿中心点 $innerDistince 与 $outerDistince 的矩形带中。" | Tee-Object -FilePath $logFile -Append  |  Write-Host 

#$widthSpan = $islandWidth * 0.2
#$heightSpan = $islandHeight * 0.2

Add-Type -TypeDefinition @"
public class Requirement{
    public long X { get; set; }
    public long Y { get; set; }
    public int NeedToAdd{get;set;}
}
"@

$requirements = @();
$needAddTotal = 0


function IsPointInAnnulus {
    param (
        [long]$px,
        [long]$py,
        [long]$left,
        [long]$bottom,
        [long]$right,
        [long]$top,
        [long]$outerLeft,
        [long]$outerBottom,
        [long]$outerRight,
        [long]$outerTop
    )

    # 检查点是否在外部矩形之内
    $inOuterRectangle = ($px -ge $outerLeft) -and ($px -le $outerRight) -and ($py -ge $outerBottom) -and ($py -le $outerTop)

    # 检查点是否在内部矩形之外
    $outInnerRectangle = ($px -lt $left) -or ($px -gt $right) -or ($py -lt $bottom) -or ($py -gt $top)

    # 如果在外部矩形内且在内部矩形外，则返回 $true
    return $inOuterRectangle -and $outInnerRectangle
}

#循环每个岛屿-$u32MaxHalf
foreach ($islandCoordinate in $islandCoordinates) {
    $left = $islandCoordinate.x - $innerDistince
    $bottom = $islandCoordinate.y - $innerDistince
    $right = $islandCoordinate.x + $innerDistince
    $top = $islandCoordinate.y + $innerDistince
    #"岛屿坐标：($($islandCoordinate.x),$($islandCoordinate.y))" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    "岛屿坐标：($($islandCoordinate.x-$u32MaxHalf),$($islandCoordinate.y-$u32MaxHalf))" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
    #"   内矩形：左下角:($left,$bottom)，右上角:($right,$top)" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor White
    "   内矩形：左下角:($($left-$u32MaxHalf),$($bottom-$u32MaxHalf))，右上角:($($right-$u32MaxHalf),$($top-$u32MaxHalf))" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor White
    $outerLeft = $islandCoordinate.x - $outerDistince
    $outerBottom = $islandCoordinate.y - $outerDistince
    $outerRight = $islandCoordinate.x + $outerDistince
    $outerTop = $islandCoordinate.y + $outerDistince
    #"   外矩形：左下角:($outerLeft,$outerBottom)，右上角:($outerRight,$outerTop)" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor White
    "   外矩形：左下角:($($outerLeft-$u32MaxHalf),$($outerBottom-$u32MaxHalf))，右上角:($($outerRight-$u32MaxHalf),$($outerTop-$u32MaxHalf))" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor White
    #查询这个区域内有没有环境船队
    $inRange = 0
    #循环所有的环境船队，看那个船队属于哪个岛屿
    foreach ($rosterCoordinate in $rosterCoordinates) {
        $pointBetweenRectangles = IsPointInAnnulus -px $rosterCoordinate.x -py $rosterCoordinate.y -left $left -bottom $bottom -right $right -top $top -outerLeft $outerLeft -outerBottom $outerBottom -outerRight $outerRight -outerTop $outerTop
        if ($pointBetweenRectangles) {
            #if ($rosterCoordinate.x -le $left -and $rosterCoordinate.x -ge $right -and $rosterCoordinate.y -ge $bottom -and $rosterCoordinate.y -le $top) {
            #"   坐标为($($rosterCoordinate.x),$($rosterCoordinate.y) 的船队处于岛屿范围之内,横纵距离分别是" | Tee-Object -FilePath $logFile -Append  |  Write-Host -NoNewline
            "   坐标为($($rosterCoordinate.x-$u32MaxHalf),$($rosterCoordinate.y-$u32MaxHalf)) 的船队处于岛屿范围之内,横纵距离分别是" | Tee-Object -FilePath $logFile -Append  |  Write-Host -NoNewline
            "($($rosterCoordinate.x - $islandCoordinate.x), $($rosterCoordinate.y - $islandCoordinate.y))" | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Yellow
            $inRange = $inRange + 1;
        }
    }
    if ($inRange -lt $environmentQuntityPerIsland) {
        $requirement = New-Object Requirement
        $requirement.X = $islandCoordinate.x
        $requirement.Y = $islandCoordinate.y
        $requirement.NeedToAdd = $environmentQuntityPerIsland - $inRange
        $requirements += $requirement
        $needAddTotal = $needAddTotal + $requirement.NeedToAdd
    }
}
if ($needAddTotal -lt 1) {
    "不需要补充环境船队" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow
    return;
}
"需要补充 $needAddTotal 个环境船队..." | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Yellow

$random = New-Object System.Random  
$errorTimes = 0

$ship_resource_quantity = 15
$ship_base_resource_quantity = 3
$base_experience = 0
$clock = '0x6'
$roster_id_sequence_number = 1

#因为船队的序列号是唯一的，为了防止出错，先给加个1
$islandEnvironmentRosterInfo.LastRosterIdSequenceNumber++

"本次造船队将从序列号 $($islandEnvironmentRosterInfo.LastRosterIdSequenceNumber) 开始" | Write-Host -ForegroundColor Green
foreach ($requirement in $requirements) {
    "岛屿: $($requirement.X),$($requirement.Y) 周围需要补充 $($requirement.NeedToAdd) 个环境船队...." | Tee-Object -FilePath $logFile -Append  |  Write-Host -ForegroundColor Blue
    for ($i = 0; $i -lt $requirement.NeedToAdd; $i++) {
        $widthRandom = $random.Next(-1 * $widthSpan, $widthSpan)
        $heightRandom = $random.Next(-1 * $heightSpan, $heightSpan)

        $rosterX = $requirement.X + $widthRandom
        $rosterY = $requirement.Y + $heightRandom

        "   横向偏移:$widthRandom,纵向偏移:$heightRandom 在($rosterX,$rosterY)处添加环境船队...." | Tee-Object -FilePath $logFile -Append  |  Write-Host 

        $rosterId = ""
        $createEnvironmentRosterResult = ""
        try {
            $command = "sui client call --package $($dataInfo.main.PackageId) --module roster_aggregate --function create_environment_roster --args  $($dataInfo.main.EnvironmentPlayId) $($islandEnvironmentRosterInfo.LastRosterIdSequenceNumber) $($dataInfo.main.Publisher) $rosterX $rosterY $ship_resource_quantity $ship_base_resource_quantity $base_experience $clock $($dataInfo.main.RosterTable) --gas-budget 42000000 --json"
            $command | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Blue
            $createEnvironmentRosterResult = Invoke-Expression -Command $command
            if (-not ('System.Object[]' -eq $createEnvironmentRosterResult.GetType())) {
                "创建环境船队时返回信息 $createEnvironmentRosterResult" | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
                $errorTimes++
                if ($errorTimes -ge $maxErrorTimes) {
                    "创建环境船队出错次数:$errorTimes,已经达到上限:$maxErrorTimes,退出..." | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
                    $islandEnvironmentRosterInfo | ConvertTo-Json | Tee-Object -FilePath $environmentRosterJsonFile | Write-Host -ForegroundColor White
                    return
                }
                continue
            }
            $createEnvironmentRosterResultObj = $createEnvironmentRosterResult | ConvertFrom-Json
            foreach ($object in $createEnvironmentRosterResultObj.objectChanges) {
                if ($object.objectType -like "*::roster::Roster") {
                    $rosterId = $object.objectId
                    "创建环境船队成功， Roster Id: $rosterId`n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Green
                    break
                }
            }
            "船队RosterId={$($dataInfo.main.EnvironmentPlayId),$($islandEnvironmentRosterInfo.LastRosterIdSequenceNumber)}" | Write-Host -ForegroundColor Blue
            "已经补充 $($roster_id_sequence_number) 只环境船队" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Yellow
            $roster_id_sequence_number++;
            $islandEnvironmentRosterInfo.LastRosterIdSequenceNumber++
        }
        catch {
            "创建环境船队失败: $($_.Exception.Message) `n" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Red
            "返回的结果为:$createEnvironmentRosterResult" | Tee-Object -FilePath $logFile -Append  |  Write-Host 
            $errorTimes++
            if ($errorTimes -ge $maxErrorTimes) {
                "创建环境船队出错次数:$errorTimes,已经达到上限:$maxErrorTimes,退出..." | Tee-Object -FilePath $logFile -Append | Write-Host  -ForegroundColor Red
                $islandEnvironmentRosterInfo | ConvertTo-Json | Tee-Object -FilePath $environmentRosterJsonFile | Write-Host -ForegroundColor White
                return
            }
            continue    
        }
    }
}
"全部补充完毕!" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Blue
$islandEnvironmentRosterInfo | ConvertTo-Json | Tee-Object -FilePath $environmentRosterJsonFile | Write-Host -ForegroundColor White
"该脚本执行后相关的日志请参考: $logFile" | Tee-Object -FilePath $logFile -Append | Write-Host -ForegroundColor Blue



