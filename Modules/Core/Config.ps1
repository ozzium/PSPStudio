# ===============================
# PSPStudio Config System
# ===============================

$Script:ConfigPath = Join-Path $Script:StudioRoot "Config\PSPStudio.json"

function Get-PSPConfig {

    if (-not (Test-Path $Script:ConfigPath)) {

        $default = @{
            Theme             = "Dark"
            LastProfile       = ""
            WindowWidth       = 1400
            WindowHeight      = 900
            EnableLogging     = $true
            SandboxMode       = $true
        }

        $default | ConvertTo-Json -Depth 5 |
            Set-Content $Script:ConfigPath -Encoding UTF8
    }

    try {
        Get-Content $Script:ConfigPath -Raw |
            ConvertFrom-Json
    }
    catch {
        Write-Warning "Failed loading config."
        return $null
    }
}

function Save-PSPConfig($Config) {

    try {
        $Config |
            ConvertTo-Json -Depth 10 |
            Set-Content $Script:ConfigPath -Encoding UTF8
    }
    catch {
        Write-Warning "Failed saving config."
    }
}

# ===============================
# Sandbox Paths
# ===============================

$Global:PSPSandboxRoot = Join-Path $Script:StudioRoot "Sandbox"
$Global:PSPProfilePath = Join-Path $Global:PSPSandboxRoot `
    "PowerShell\Microsoft.PowerShell_profile.ps1"
$Global:PSPConfig = Get-PSPConfig