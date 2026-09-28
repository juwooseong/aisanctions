param(
    [Parameter(Mandatory = $true)]
    [string]$WorkbookPath,
    [Parameter(Mandatory = $true)]
    [string]$ManifestPath
)

$ErrorActionPreference = "Stop"

function OfficeRgb([int]$r, [int]$g, [int]$b) {
    return $r + ($g * 256) + ($b * 65536)
}

function Set-ShapeText($shape, [string]$text, [int]$fontSize, [bool]$bold, [int]$color, [bool]$wrap = $false) {
    $shape.TextFrame2.TextRange.Text = $text
    $shape.TextFrame2.TextRange.Font.Name = "Malgun Gothic"
    $shape.TextFrame2.TextRange.Font.Size = $fontSize
    $shape.TextFrame2.TextRange.Font.Bold = $(if ($bold) { -1 } else { 0 })
    $shape.TextFrame2.TextRange.Font.Fill.ForeColor.RGB = $color
    $shape.TextFrame2.TextRange.ParagraphFormat.Alignment = 2
    $shape.TextFrame2.VerticalAnchor = 3
    $shape.TextFrame2.WordWrap = $(if ($wrap) { -1 } else { 0 })
    $shape.TextFrame2.MarginLeft = 4
    $shape.TextFrame2.MarginRight = 4
    $shape.TextFrame2.MarginTop = 2
    $shape.TextFrame2.MarginBottom = 2
}

$manifest = Get-Content -LiteralPath $ManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

try {
    $workbook = $excel.Workbooks.Open($WorkbookPath)
    try {
        foreach ($chart in $manifest.charts) {
            $sheet = $workbook.Worksheets.Item([string]$chart.sheet)
            $anchor = $sheet.Range([string]$chart.anchor)
            $originLeft = [double]$anchor.Left
            $originTop = [double]$anchor.Top
            $scale = [Math]::Min(0.74, 680.0 / [double]$chart.width)

            for ($i = $sheet.Shapes.Count; $i -ge 1; $i--) {
                $existing = $sheet.Shapes.Item($i)
                if ([string]$existing.AlternativeText -like "AI_FLOWCHART*") {
                    $existing.Delete()
                }
                [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($existing)
            }

            $title = $sheet.Shapes.AddTextbox(
                1,
                $originLeft,
                $originTop,
                [double]$chart.width * $scale,
                20
            )
            $title.Name = "FlowTitle_" + [string]$chart.screen_id
            $title.AlternativeText = "AI_FLOWCHART_TITLE"
            $title.Fill.Visible = 0
            $title.Line.Visible = 0
            Set-ShapeText $title ([string]$chart.title) 12 $true (OfficeRgb 55 65 81)

            $shapeById = @{}
            foreach ($node in $chart.nodes) {
                $left = $originLeft + ([double]$node.x * $scale)
                $top = $originTop + 24 + ([double]$node.y * $scale)
                $width = [double]$node.w * $scale
                $height = [double]$node.h * $scale

                switch ([string]$node.type) {
                    "시작" {
                        $shapeType = 9
                        $fillColor = OfficeRgb 107 114 128
                        $lineColor = OfficeRgb 75 85 99
                        $fontColor = OfficeRgb 255 255 255
                    }
                    "종료" {
                        $shapeType = 9
                        $fillColor = OfficeRgb 71 85 105
                        $lineColor = OfficeRgb 51 65 85
                        $fontColor = OfficeRgb 255 255 255
                    }
                    "분기" {
                        $shapeType = 4
                        $fillColor = OfficeRgb 226 232 240
                        $lineColor = OfficeRgb 148 163 184
                        $fontColor = OfficeRgb 30 41 59
                    }
                    default {
                        $shapeType = 5
                        $fillColor = OfficeRgb 241 245 249
                        $lineColor = OfficeRgb 100 116 139
                        $fontColor = OfficeRgb 30 41 59
                    }
                }

                $shape = $sheet.Shapes.AddShape($shapeType, $left, $top, $width, $height)
                $shape.Name = "FlowNode_" + [string]$chart.screen_id + "_" + [string]$node.id
                $shape.AlternativeText = "AI_FLOWCHART_NODE"
                $shape.Fill.ForeColor.RGB = $fillColor
                $shape.Fill.Solid()
                $shape.Line.ForeColor.RGB = $lineColor
                $shape.Line.Weight = 1.5
                Set-ShapeText $shape ([string]$node.name) 9 $true $fontColor
                $shapeById[[string]$node.id] = $shape
            }

            foreach ($edge in $chart.edges) {
                $source = $shapeById[[string]$edge.source]
                $target = $shapeById[[string]$edge.target]
                if ($null -eq $source -or $null -eq $target) {
                    continue
                }

                $connectorType = $(if ([bool]$edge.loop) { 2 } else { 1 })
                $x1 = [double]$source.Left + ([double]$source.Width / 2)
                $y1 = [double]$source.Top + [double]$source.Height
                $x2 = [double]$target.Left + ([double]$target.Width / 2)
                $y2 = [double]$target.Top
                $connector = $sheet.Shapes.AddConnector($connectorType, $x1, $y1, $x2, $y2)
                $connector.Name = "FlowEdge_" + [string]$chart.screen_id + "_" + [string]$edge.id
                $connector.AlternativeText = "AI_FLOWCHART_EDGE"
                $connector.Line.ForeColor.RGB = $(if ([bool]$edge.loop) {
                    OfficeRgb 148 163 184
                } else {
                    OfficeRgb 71 85 105
                })
                $connector.Line.Weight = 1.5
                $connector.Line.EndArrowheadStyle = 3
                try {
                    $connector.ConnectorFormat.BeginConnect($source, 3)
                    $connector.ConnectorFormat.EndConnect($target, 1)
                    $connector.RerouteConnections()
                } catch {
                    # 연결 지점이 지원되지 않는 도형은 계산 좌표를 유지한다.
                }

                if (-not [string]::IsNullOrWhiteSpace([string]$edge.label)) {
                    $labelLeft = ([double]$source.Left + [double]$target.Left) / 2
                    $labelTop = ([double]$source.Top + [double]$target.Top) / 2
                    $label = $sheet.Shapes.AddTextbox(1, $labelLeft, $labelTop, 105, 18)
                    $label.Name = "FlowLabel_" + [string]$chart.screen_id + "_" + [string]$edge.id
                    $label.AlternativeText = "AI_FLOWCHART_LABEL"
                    $label.Fill.Visible = 0
                    $label.Line.Visible = 0
                    Set-ShapeText $label ([string]$edge.label) 8 $false (OfficeRgb 100 116 139)
                }
            }

        }

        $workbook.Save()
    }
    finally {
        $workbook.Close($true)
        [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($workbook)
    }
}
finally {
    $excel.Quit()
    [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel)
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}
