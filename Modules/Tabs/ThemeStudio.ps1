Register-PSPTab -Name "Theme Studio" -Render {

    param($TabPage)

    $panel = New-Object System.Windows.Forms.Panel
    $panel.Dock = "Fill"

    # ===== Toolbar =====

    $toolbar = New-Object System.Windows.Forms.FlowLayoutPanel
    $toolbar.Dock = "Top"
    $toolbar.Height = 50
    $toolbar.Padding = New-Object System.Windows.Forms.Padding(8)

    $refreshBtn = New-Object System.Windows.Forms.Button
    $refreshBtn.Text = "Refresh Themes"
    $refreshBtn.Width = 160

    $applyBtn = New-Object System.Windows.Forms.Button
    $applyBtn.Text = "Apply Theme"
    $applyBtn.Width = 140

    $toolbar.Controls.Add($refreshBtn)
    $toolbar.Controls.Add($applyBtn)

    # ===== Theme List =====

    $themeList = New-Object System.Windows.Forms.ListBox
    $themeList.Dock = "Left"
    $themeList.Width = 300
    $themeList.Font = New-Object System.Drawing.Font("Segoe UI", 11)

    # ===== Preview =====

    $preview = New-Object System.Windows.Forms.RichTextBox
    $preview.Dock = "Fill"
    $preview.ReadOnly = $true
    $preview.BackColor = [System.Drawing.Color]::FromArgb(12,12,12)
    $preview.ForeColor = [System.Drawing.Color]::White
    $preview.Font = New-Object System.Drawing.Font("Cascadia Code", 12)
    $preview.BorderStyle = "None"

    $preview.Text = @"
PSPStudio Theme Preview

Select a theme from the left.
"@

    # ===== Theme Loader =====

    function Load-Themes {

        $themeList.Items.Clear()

        $themes = Get-PSPOhMyPoshThemes

        foreach ($theme in $themes) {
            [void]$themeList.Items.Add($theme.Name)
        }

        if ($themeList.Items.Count -eq 0) {
            $preview.Text = "No Oh My Posh themes were found."
        }
    }

    # ===== Selection Changed =====

    $themeList.Add_SelectedIndexChanged({

        if (-not $themeList.SelectedItem) { return }

        $themeName = $themeList.SelectedItem.ToString()

        $preview.Text = @"
Theme Selected

$themeName

Preview rendering support coming soon.
"@
    })

    # ===== Apply Theme =====

    $applyBtn.Add_Click({

        if (-not $themeList.SelectedItem) {
            return
        }

        $selectedTheme = $themeList.SelectedItem.ToString()

        if (-not ($Global:PSPConfig.PSObject.Properties.Name -contains "CurrentTheme")) {

            $Global:PSPConfig | Add-Member `
                -NotePropertyName "CurrentTheme" `
                -NotePropertyValue ""
        }

        $Global:PSPConfig.CurrentTheme = $selectedTheme

        Save-PSPConfig $Global:PSPConfig

        [System.Windows.Forms.MessageBox]::Show(
            "Theme applied: $selectedTheme",
            "PSPStudio"
        ) | Out-Null
    })

    # ===== Refresh =====

    $refreshBtn.Add_Click({
        Load-Themes
    })

    # ===== Initial Load =====

    Load-Themes

    # ===== Assemble =====

    $panel.Controls.Add($preview)
    $panel.Controls.Add($themeList)
    $panel.Controls.Add($toolbar)

    $TabPage.Controls.Add($panel)
}