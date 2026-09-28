<#
.SYNOPSIS
  반입용 ZIP 생성 (WAR + SHA256 + 선택적 exploded)

.EXAMPLE
  .\package_for_transfer.ps1
#>
[CmdletBinding()]
param(
    [string]$OutDir = ''
)

$ErrorActionPreference = 'Stop'
$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
Set-Location $ProjectRoot

& (Join-Path $PSScriptRoot 'hash_war.ps1')
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$wars = Get-ChildItem (Join-Path $ProjectRoot 'target') -Filter 'aisanction-*.war' |
    Where-Object { $_.Name -notmatch 'sources|javadoc' } |
    Sort-Object LastWriteTime -Descending
$war = $wars | Select-Object -First 1
if (-not $war) {
    Write-Error 'WAR not found'
    exit 1
}

$Stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
if (-not $OutDir) {
    $OutDir = Join-Path $ProjectRoot "target\transfer_$Stamp"
}
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

Copy-Item $war.FullName -Destination $OutDir
$sha = Join-Path $war.DirectoryName 'war.sha256'
if (Test-Path $sha) { Copy-Item $sha -Destination $OutDir }

$zip = Join-Path $ProjectRoot "target\aisanction_transfer_$Stamp.zip"
if (Test-Path $zip) { Remove-Item $zip -Force }
Compress-Archive -Path (Join-Path $OutDir '*') -DestinationPath $zip
Write-Host "Transfer package: $zip"
Write-Host 'success'
exit 0
