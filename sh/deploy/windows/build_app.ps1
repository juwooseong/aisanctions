<#
.SYNOPSIS
  Windows용 aisanction Maven WAR 빌드

.DESCRIPTION
  개발 PC / VDI / Build Agent에서 실행한다.
  산출물: target\aisanction-*.war  (및 war plugin exploded 디렉터리)

.PARAMETER Env
  Maven -Denv 값. d=개발, p=운영, 생략 시 프로파일 미지정(-DskipTests clean package)

.PARAMETER SkipTests
  기본 $true

.EXAMPLE
  .\build_app.ps1 -Env d
  .\build_app.ps1 -Env p
  .\build_app.ps1
#>
[CmdletBinding()]
param(
    [ValidateSet('d', 'p', '')]
    [string]$Env = '',
    [bool]$SkipTests = $true
)

$ErrorActionPreference = 'Stop'

# 스크립트: sh/deploy/windows → 프로젝트 루트(ta_ui-master)
$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
Set-Location $ProjectRoot

$LogDir = Join-Path $ProjectRoot 'target\deploy-logs'
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$Stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$LogFile = Join-Path $LogDir "aisanction_maven_build_$Stamp.log"

Write-Host "MAVEN_BUILD_START  ProjectRoot=$ProjectRoot"
Write-Host "Log=$LogFile"

java -version 2>&1 | Tee-Object -FilePath $LogFile -Append
mvn -v 2>&1 | Tee-Object -FilePath $LogFile -Append

$mvnArgs = @('clean', 'package')
if ($SkipTests) {
    $mvnArgs += '-Dmaven.test.skip=true'
    $mvnArgs += '-DskipTests'
}
if ($Env) {
    $mvnArgs += "-Denv=$Env"
}

Write-Host ("mvn " + ($mvnArgs -join ' '))
& mvn @mvnArgs 2>&1 | Tee-Object -FilePath $LogFile -Append
if ($LASTEXITCODE -ne 0) {
    Write-Error "Maven Package Build failed! See $LogFile"
    exit 1
}

Write-Host 'success'
'success' | Out-File -FilePath $LogFile -Append -Encoding utf8
exit 0
