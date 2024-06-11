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


#释放的块序号
$seqNo = 1


$u32Max = 4294967295
$u32MaxHalf = 2147483647


$rand_rate_x = 0.2
$rand_rate_y = 0.25

$original_x = 0 # $u32MaxHalf
$original_y = 0 # $u32MaxHalf



$island_width = 50 #5000
$island_height = 50 #5000


$block_width = 500 #50000
$block_height = 500 #50000

if ($block_width -lt $island_width -or $block_height -lt $island_height) {
    "分配区域的尺寸不能小于岛屿的尺寸" | Write-Host -ForegroundColor Red
}


#分配的区域可以放多少行小岛
$line = [Int32][Math]::Floor($block_height / $island_height)
#分配的区域可以放多少列小岛
$column = [Int32][Math]::Floor($block_width / $island_width)

#岛与岛之间纵向空隙总和
$vertical_gap = $block_height % $island_height
#岛与岛之间横向空隙总和
$horizontal_gap = $block_width % $island_width

#行与行之间的空隙，这里采用了直接除以多少行的做法，还可以采用除以($line-1)和除以($line+1)的做法。
#直接除以行数，那么在第一行后才累加空隙，最后一行后防止剩余空隙
$per_vertical_gap = [Int32][Math]::Floor($vertical_gap / $line)
$per_horizontal_gap = [Int32][Math]::Floor($horizontal_gap / $column)

"每块区域大小(宽: $block_width ,高: $block_height ),岛屿大小(宽: $island_width ,高: $island_height), 可以分配岛屿个数: $($line*$column) ,其中横向可以摆放 $column 列,纵向可以摆放 $line 行,列之间空隙 $per_vertical_gap ,行之间空隙 $per_horizontal_gap" | Write-Host -ForegroundColor Green


$horizontal_number = [Int32][Math]::Floor($u32Max / $block_width) 
if ($horizontal_number % 2 -eq 1) {
    $horizontal_number = $horizontal_number - 1
}
$vertical_number = [Int32][Math]::Floor($u32Max / $block_height) 
if ($vertical_number % 2 -eq 1) {
    $vertical_number = $vertical_number - 1
}

"一共存在 " + $horizontal_number * $vertical_number + " 个区" | Write-Host -ForegroundColor Blue


#最多能有多少圈？
$maxLoop = $horizontal_number
if ($horizontal_number -ge $vertical_number) { 
    $maxLoop = $vertical_number 
}

# 包括本圈在内一共多少区
$current = 0 
$next = 0
$loop = 0
for ($i = 1; $i -le $maxLoop ; $i++) {    
    $current = $current + (2 * $i - 1) * 4;
    $next = $current + (2 * ($i + 1) - 1) * 4
    if ($seqNo -le $current) {
        $loop = $i
        "位于第 " + $loop + " 圈" | Write-Host
        break;
    }
    if ( $seqNo -le $next) {
        $loop = $i + 1
        "位于第 " + $loop + " 圈" | Write-Host
        break;
    }
}
if ($loop -eq 0) {
    "超范围了" | Write-Host -ForegroundColor Red
}
#$current_loop_block = 4
#$blocks_per_quadrant = 1
$left = 0
$bottom = 0 
if ($loop -eq 1) {
    $before = 0
    if ($seqNo -eq 1) {
        $left = $original_x
        $bottom = $original_y        
    }
    elseif ($seqNo -eq 2) {
        $left = $original_x - $block_width
        $bottom = $original_y     
    }
    elseif ($seqNo -eq 3) {
        $left = $original_x - $block_width
        $bottom = $original_y - $block_height 
    }
    elseif ($seqNo -eq 4) {
        $left = $original_x
        $bottom = $original_y - $block_height 
    }
}
else {
    $before = $current
    $blocks_per_quadrant = 2 * $loop - 1;
    $current_loop_block = $blocks_per_quadrant * 4
    "序号为 $seqNo 的小岛位于第 $loop 圈,本圈之前包括 $before 区,本圈共有 $current_loop_block 个区，每个象限 $blocks_per_quadrant 个" | Write-Host
    $quadrantNo = 0
    $currentLoopSeqNo = ($seqNo - $before)
    #如果能够整除
    if ($currentLoopSeqNo % $blocks_per_quadrant -eq 0) {
        $quadrantNo = $currentLoopSeqNo / $blocks_per_quadrant
    }
    else {
        $quadrantNo = ([Int32][Math]::Floor($currentLoopSeqNo / $blocks_per_quadrant) + 1)
    }
    "位于第 $quadrantNo 象限" | Write-Host -ForegroundColor DarkGreen  

    #在某个圈的某个象限内的块分成3个部分，前半部分，中间，以及后半部分
    $half_quantity = $loop - 1
    "第 $loop 圈在每个象限内分成 3 个部分，前半部分和后半部分各有 $half_quantity 个块。" | Write-Host -ForegroundColor Yellow 
    $begin = $before + ($quadrantNo - 1) * $blocks_per_quadrant + 1
    "象限内的起始元素为：$begin" | Write-Host -ForegroundColor Yellow 
    $first_half_blocks = @()
    $middle = $begin + $half_quantity 
    $second_half_blocks = @()
    for ($i = 0; $i -lt $half_quantity; $i++) {
        $first_half_blocks += $begin + $i
        $second_half_blocks += $middle + $i + 1
    }
    "象限内的前半部分块的序号为：$first_half_blocks ，中间为为 $middle ，后半部分块的序号为 $second_half_blocks" | Write-Host -ForegroundColor Green 

    if ($quadrantNo -eq 1) {
        $middle_left = $original_x + ($loop - 1) * $block_width
        $middle_bottom = $original_y + ($loop - 1) * $block_height  
        if ($first_half_blocks -contains $seqNo) {
            $index = $first_half_blocks.IndexOf($seqNo)
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的前半部分，位置索引为:$index" | Write-Host -ForegroundColor Cyan 
            $left = $middle_left
            $bottom = $original_y + $index * $block_height        
        }
        elseif ( $middle -eq $seqNo) {
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的中间" | Write-Host -ForegroundColor Cyan
            $left = $middle_left
            $bottom = $middle_bottom
        }
        elseif ($second_half_blocks -contains $seqNo) {
            $index = $second_half_blocks.IndexOf($seqNo)
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的后半部分，位置索引为: $index" | Write-Host -ForegroundColor Cyan 
            $bottom = $middle_bottom
            $left = $middle_bottom - ($index + 1) * $block_width
        }
        else {
            "有问题！"  | Write-Host -ForegroundColor Red 
            Set-Location $startLocation
            return
        }
    }
    elseif ($quadrantNo -eq 2) {
        $middle_left = $original_x - $loop * $block_width
        $middle_bottom = $original_y + ($loop - 1) * $block_height  
        if ($first_half_blocks -contains $seqNo) {
            $index = $first_half_blocks.IndexOf($seqNo)
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的前半部分，位置索引为:$index" | Write-Host -ForegroundColor Cyan 
            $left = $original_x - 1 * ($index + 1) * $block_width
            $bottom = $middle_bottom      
        }
        elseif ( $middle -eq $seqNo) {
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的中间" | Write-Host -ForegroundColor Cyan
            $left = $middle_left
            $bottom = $middle_bottom
        }
        elseif ($second_half_blocks -contains $seqNo) {
            $index = $second_half_blocks.IndexOf($seqNo)
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的后半部分，位置索引为: $index" | Write-Host -ForegroundColor Cyan 
            $left = $middle_left
            $bottom = $middle_bottom - ($index + 1) * $block_height  
        }
        else {
            "有问题！"  | Write-Host -ForegroundColor Red 
            Set-Location $startLocation
            return
        }
    }
    elseif ($quadrantNo -eq 3) {
        $middle_left = $original_x - $loop * $block_width
        $middle_bottom = $original_y - $loop * $block_height  
        if ($first_half_blocks -contains $seqNo) {
            $index = $first_half_blocks.IndexOf($seqNo)
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的前半部分，位置索引为:$index" | Write-Host -ForegroundColor Cyan 
            $left = $middle_left
            $bottom = $original_y - 1 * ($index + 1) * $block_height    
        }
        elseif ( $middle -eq $seqNo) {
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的中间" | Write-Host -ForegroundColor Cyan
            $left = $middle_left
            $bottom = $middle_bottom
        }
        elseif ($second_half_blocks -contains $seqNo) {
            $index = $second_half_blocks.IndexOf($seqNo)
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的后半部分，位置索引为: $index" | Write-Host -ForegroundColor Cyan 
            $left = $middle_left + ($index + 1) * $block_width
            $bottom = $middle_bottom 
        }
        else {
            "有问题！"  | Write-Host -ForegroundColor Red 
            Set-Location $startLocation
            return
        }
    }
    elseif ($quadrantNo -eq 4) {
        $middle_left = $original_x + ($loop - 1) * $block_width
        $middle_bottom = $original_y - $loop * $block_height  
        if ($first_half_blocks -contains $seqNo) {
            $index = $first_half_blocks.IndexOf($seqNo)
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的前半部分，位置索引为:$index" | Write-Host -ForegroundColor Cyan 
            $left = $original_x + ($index) * $block_width
            $bottom = $middle_bottom
        }
        elseif ( $middle -eq $seqNo) {
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的中间" | Write-Host -ForegroundColor Cyan
            $left = $middle_left
            $bottom = $middle_bottom
        }
        elseif ($second_half_blocks -contains $seqNo) {
            $index = $second_half_blocks.IndexOf($seqNo)
            "序号为 $seqNo 的块，位于第 $quadrantNo 象限的后半部分，位置索引为: $index" | Write-Host -ForegroundColor Cyan 
            $left = $middle_left
            $bottom = $middle_bottom + ($index + 1) * $block_height  
        }
        else {
            "有问题！"  | Write-Host -ForegroundColor Red 
            Set-Location $startLocation
            return
        }
    }
    else {
        "非法象限: $quadrantNo"  | Write-Host -ForegroundColor Red 
        Set-Location $startLocation
    }
}
"左下角坐标为：($left,$bottom)" | Write-Host -ForegroundColor Yellow

Add-Type -TypeDefinition @"
public class Coordinate{
    public int InitX { get; set; }
    public int InitY { get; set; }
    public int RateX { get; set; }
    public int RateY { get; set; }
    public int RandomX { get; set; }
    public int RandomY { get; set; }
}
"@
$coordinates = @()
for ($i = 0; $i -lt $column; $i++) {
    "第 $($i+1) 列中心坐标" | Write-Host -ForegroundColor Red 
    for ($j = 0; $j -lt $line; $j++) {
        $x = $left + ($i) * ($per_horizontal_gap + $island_width) + $island_width / 2
        $y = $bottom + ($j) * ($per_horizontal_gap + $island_height) + $island_height / 2
        "初始：($x,$y)" | Write-Host -ForegroundColor Green -NoNewline
        $coordinate = New-Object Coordinate
        $coordinate.InitX = $x
        $coordinate.InitY = $y
        $a = (-1 * $rand_rate_x * 100)
        $b = ($rand_rate_x * 100 + 1)
        $coordinate.RateX = Get-Random -Minimum $a -Maximum $b 
        $m = (-1 * $rand_rate_y * 100)
        $n = ($rand_rate_y * 100 + 1)
        $coordinate.RateY = Get-Random -Minimum $m -Maximum $n
        "，分别波动:($($coordinate.RateX/100),$($coordinate.RateY/100)) 后变为" | Write-Host -ForegroundColor Green -NoNewline
        $coordinate.RandomX = $coordinate.InitX + ($island_width * $coordinate.RateX) / 100
        $coordinate.RandomY = $coordinate.InitY + ($island_height * $coordinate.RateY) / 100
        "($($coordinate.RandomX),$($coordinate.RandomY))" | Write-Host -ForegroundColor Green 
        $coordinates += $coordinate
    }
    "`n" | Write-Host
}















