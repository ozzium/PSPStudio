# ===============================
# PSPStudio Tab Registry
# ===============================

$Global:PSPTabs = @()

function Register-PSPTab {

    param(
        [string]$Name,
        [scriptblock]$Render
    )

    $Global:PSPTabs += [pscustomobject]@{
        Name   = $Name
        Render = $Render
    }
}