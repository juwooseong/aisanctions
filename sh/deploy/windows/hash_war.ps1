<#
.SYNOPSIS
  WAR SHA256 산출 (D-501 STP-010)

.EXAMPLE
  .\hash_war.ps1
  .\hash_war.ps1 -WarPath .\target\aisanction-1.0.0.war
#>
[CmdletBinding()]
param(
    [string]$WarPath = ''
)

$ErrorActionPreference = 'Stop'
$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
Set-Location $ProjectRoot

if (-not $WarPath) {
    $wars = Get-ChildItem -Path (Join-Path $ProjectRoot 'target') -Filter 'aisanction-*.war' -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -notmatch 'sources|javadoc' }
    if (-not $wars) {
        Write-Error 'target\aisanction-*.war 없음. 먼저 build_app.ps1 실행.'
        exit 1
    }
    $WarPath = $wars | Sort-Object LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty FullName
}

$WarPath = (Resolve-Path $WarPath).Path
$hash = Get-FileHash -Path $WarPath -Algorithm SHA256
$out = Join-Path (Split-Path $WarPath -Parent) 'war.sha256'
"$($hash.Hash)  $(Split-Path $WarPath -Leaf)" | Out-File -FilePath $out -Encoding ascii
Write-Host "WAR=$WarPath"
Write-Host "SHA256=$($hash.Hash)"
Write-Host "Written=$out"
exit 0
