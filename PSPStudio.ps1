# ===============================
# PSPStudio Launcher
# ===============================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Script:StudioRoot = $PSScriptRoot

# Core modules first
$CoreModules = @(
    "Modules\Core\Config.ps1",
    "Modules\Core\Helpers.ps1",
    "Modules\Core\Logging.ps1",
    "Modules\Core\Runspaces.ps1",
	"Modules\Core\Tabs.ps1"
)

foreach ($m in $CoreModules) {
    $path = Join-Path $Script:StudioRoot $m
    if (Test-Path $path) {
        . $path
    } else {
        Write-Warning "Missing module: $m"
    }
}

# Services
$ServiceModules = Get-ChildItem (
    Join-Path $Script:StudioRoot "Modules\Services"
) -Filter *.ps1 -ErrorAction SilentlyContinue

foreach ($m in $ServiceModules) {
    . $m.FullName
}

# UI
$UIModules = @(
    "Modules\UI\Theme.ps1",
    "Modules\UI\Controls.ps1",
    "Modules\UI\MainForm.ps1"
)

foreach ($m in $UIModules) {
    $path = Join-Path $Script:StudioRoot $m
    . $path
}

# Tabs
$TabModules = Get-ChildItem (
    Join-Path $Script:StudioRoot "Modules\Tabs"
) -Filter *.ps1 -ErrorAction SilentlyContinue

foreach ($m in $TabModules) {
    . $m.FullName
}

# Launch
Start-PSPStudio