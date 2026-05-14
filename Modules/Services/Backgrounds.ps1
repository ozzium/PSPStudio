function Get-PSPBackgroundImage {

    if ($Global:PSPConfig.BackgroundImage -and
        (Test-Path $Global:PSPConfig.BackgroundImage)) {

        return [System.Drawing.Image]::FromFile(
            $Global:PSPConfig.BackgroundImage
        )
    }

    return $null
}