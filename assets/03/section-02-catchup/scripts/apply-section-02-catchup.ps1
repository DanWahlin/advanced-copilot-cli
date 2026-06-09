param(
    [switch]$Force,
    [string]$TargetRepo = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$AssetRoot = (Resolve-Path (Join-Path $ScriptDir "..")).Path
$TargetRoot = (Resolve-Path $TargetRepo).Path

$PackageJson = Join-Path $TargetRoot "package.json"
$ServicesDir = Join-Path $TargetRoot "services"

if (-not (Test-Path -Path $PackageJson -PathType Leaf) -or -not (Test-Path -Path $ServicesDir -PathType Container)) {
    Write-Host "This does not look like the AssetTrack repository root: $TargetRoot" -ForegroundColor Red
    Write-Host "Expected to find package.json and services/." -ForegroundColor Red
    exit 1
}

$SourceRoots = @(
    Join-Path $AssetRoot ".github"
    Join-Path $AssetRoot ".copilot"
)

$SourceFiles = Get-ChildItem -Path $SourceRoots -File -Recurse | Sort-Object FullName
$Existing = @()

foreach ($SourceFile in $SourceFiles) {
    $RelativePath = [System.IO.Path]::GetRelativePath($AssetRoot, $SourceFile.FullName)
    $Destination = Join-Path $TargetRoot $RelativePath
    if (Test-Path -Path $Destination) {
        $Existing += $RelativePath
    }
}

if (-not $Force -and $Existing.Count -gt 0) {
    Write-Host "Refusing to overwrite existing files. Re-run with -Force to overwrite:" -ForegroundColor Red
    foreach ($Path in $Existing) {
        Write-Host "  $Path" -ForegroundColor Red
    }
    exit 1
}

foreach ($SourceFile in $SourceFiles) {
    $RelativePath = [System.IO.Path]::GetRelativePath($AssetRoot, $SourceFile.FullName)
    $Destination = Join-Path $TargetRoot $RelativePath
    $DestinationDir = Split-Path -Parent $Destination

    if (-not (Test-Path -Path $DestinationDir -PathType Container)) {
        New-Item -ItemType Directory -Path $DestinationDir | Out-Null
    }

    Copy-Item -Path $SourceFile.FullName -Destination $Destination -Force:$Force
}

Write-Host "Section 02 catch-up assets copied to $TargetRoot."
Write-Host ""
Write-Host "Next verification steps from the AssetTrack repository root:"
Write-Host "  1. Run /instructions and confirm repo and scoped instructions are loaded."
Write-Host "  2. Run /agent and confirm accessibility-updater is available."
Write-Host "  3. Run /skills and confirm make-repo-contribution is available."
