# ===============================
# PSPStudio Logging
# ===============================

$Script:LogDir = Join-Path $Script:StudioRoot "Logs"

if (-not (Test-Path $Script:LogDir)) {
    New-Item -ItemType Directory -Path $Script:LogDir | Out-Null
}

function Write-PSPLog {

    param(
        [string]$Message,
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $line = "[{0}] [{1}] {2}" -f $timestamp, $Level, $Message

    $logFile = Join-Path $Script:LogDir (
        "PSPStudio-{0}.log" -f (Get-Date -Format "yyyyMMdd")
    )

    Add-Content -Path $logFile -Value $line
}