# =========================================
# PSPStudio Preview Renderer
# =========================================

function Get-PSPPreviewText {

    return @"
╭─ PSPStudio Preview ───────────────────────────────╮

  Ozzium@RavenStudio
  ~/Documents/GitHub/PSPStudio

  ❯ git status

  On branch main
  Your branch is up to date with 'origin/main'.

  nothing to commit, working tree clean

  ❯ oh-my-posh init pwsh

  Theme loaded successfully.

╰───────────────────────────────────────────────────╯
"@
}

function Get-PSPTerminalFont {

    $fontName = "Cascadia Code"
    $fontSize = 12

    if ($Global:PSPConfig.TerminalFont) {
        $fontName = $Global:PSPConfig.TerminalFont
    }

    if ($Global:PSPConfig.TerminalFontSize) {
        $fontSize = $Global:PSPConfig.TerminalFontSize
    }

    return New-Object System.Drawing.Font(
        $fontName,
        $fontSize
    )
}

function Update-PSPTerminalPreview {

    param(
        [System.Windows.Forms.RichTextBox]$TerminalText,
        [System.Windows.Forms.Control]$Container
    )

    if ($null -eq $TerminalText) {
        return
    }

    # Text
    $TerminalText.Text = Get-PSPPreviewText

    # Font
    $TerminalText.Font = Get-PSPTerminalFont

    # Foreground
    $TerminalText.ForeColor =
        [System.Drawing.Color]::FromArgb(220,220,220)

    # Background
    $TerminalText.BackColor =
        [System.Drawing.Color]::FromArgb(12,12,12)

    # Background image
    if (
        $Container -and
        $Global:PSPConfig.BackgroundImage -and
        (Test-Path $Global:PSPConfig.BackgroundImage)
    ) {

        try {

            if ($Container.BackgroundImage) {
                $old = $Container.BackgroundImage
                $Container.BackgroundImage = $null
                $old.Dispose()
            }

            $img = [System.Drawing.Bitmap]::FromFile(
                $Global:PSPConfig.BackgroundImage
            )

            $Container.BackgroundImage = $img
            $Container.BackgroundImageLayout = "Zoom"
        }
        catch {
            Write-PSPLog $_.Exception.Message "ERROR"
        }
    }
}

$Global:PSPPreviewTargets = @{}

function Register-PSPPreviewTarget {
    param(
        [string]$Name,
        [System.Windows.Forms.RichTextBox]$TerminalText,
        [System.Windows.Forms.Control]$Container
    )

    $Global:PSPPreviewTargets[$Name] = [pscustomobject]@{
        TerminalText = $TerminalText
        Container    = $Container
    }
}

function Refresh-PSPPreview {
    param([string]$Name = "Terminal")

    if (-not $Global:PSPPreviewTargets.ContainsKey($Name)) {
        return
    }

    $target = $Global:PSPPreviewTargets[$Name]

    Update-PSPTerminalPreview `
        -TerminalText $target.TerminalText `
        -Container $target.Container
}