param(
    [Parameter(Mandatory = $true)][string]$MaaDir,
    [switch]$Rollback
)

$ErrorActionPreference = "Stop"
$packDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$backupDir = Join-Path $MaaDir ("backup-openvino-" + (Get-Date -Format "yyyyMMdd-HHmmss") + "-" + [guid]::NewGuid().ToString("N").Substring(0, 8))
$manifest = Join-Path $backupDir "added-files.txt"

function Restore-Backup([string]$dir) {
    if (-not (Test-Path $dir)) { return }
    Get-ChildItem $dir -File | Where-Object { $_.Name -ne "added-files.txt" } | ForEach-Object {
        Copy-Item $_.FullName (Join-Path $MaaDir $_.Name) -Force
    }
    $addedList = Join-Path $dir "added-files.txt"
    if (Test-Path $addedList) {
        Get-Content $addedList | Where-Object { $_ } | ForEach-Object {
            $installed = Join-Path $MaaDir $_
            if (Test-Path $installed) { Remove-Item $installed -Force }
        }
    }
}

if ($Rollback) {
    $latest = Get-ChildItem -Directory -Filter "backup-openvino-*" -Path $MaaDir |
        Sort-Object Name -Descending | Select-Object -First 1
    if (-not $latest) { throw "No backup found under $MaaDir" }
    Restore-Backup $latest.FullName
    Write-Host "Rolled back from $($latest.FullName)"
    exit 0
}

function Backup-And-Copy([string]$src, [string]$dstDir) {
    $name = Split-Path -Leaf $src
    $dst = Join-Path $dstDir $name
    New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
    if (Test-Path $dst) {
        Copy-Item $dst (Join-Path $backupDir $name) -Force
    } else {
        Add-Content -Path $manifest -Value $name
    }
    Copy-Item $src $dst -Force
}

try {
    Get-ChildItem $packDir -Filter "*.dll" | ForEach-Object {
        Backup-And-Copy $_.FullName $MaaDir
    }
} catch {
    Write-Warning "Install failed, restoring previous files: $_"
    Restore-Backup $backupDir
    throw
}

Write-Host "Installed OpenVINO pack into $MaaDir"
if (Test-Path $backupDir) { Write-Host "Backup: $backupDir" }
