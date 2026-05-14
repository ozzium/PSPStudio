Register-PSPTab -Name "Terminal Preview" -Render {

    param($TabPage)

    $panel = New-Object System.Windows.Forms.Panel
    $panel.Dock = "Fill"
    $panel.BackColor = [System.Drawing.Color]::FromArgb(18,18,18)

    $toolbar = New-Object System.Windows.Forms.FlowLayoutPanel
    $toolbar.Dock = "Top"
    $toolbar.Height = 50
    $toolbar.Padding = New-Object System.Windows.Forms.Padding(8)
	$toolbar.BackColor = [System.Drawing.Color]::FromArgb(24,24,24)

	$refreshBtn = New-Object System.Windows.Forms.Button
	$refreshBtn.Text = "Refresh Preview"
	$refreshBtn.Width = 160
	$refreshBtn.Height = 32
	$refreshBtn.BackColor = [System.Drawing.Color]::FromArgb(45,45,48)
	$refreshBtn.ForeColor = [System.Drawing.Color]::White
	$refreshBtn.FlatStyle = "Flat"

	$accentBtn = New-Object System.Windows.Forms.Button
	$accentBtn.Text = "Apply Accent"
	$accentBtn.Width = 140
	$accentBtn.Height = 32
	$accentBtn.BackColor = [System.Drawing.Color]::FromArgb(80,45,120)
	$accentBtn.ForeColor = [System.Drawing.Color]::White
	$accentBtn.FlatStyle = "Flat"

    $toolbar.Controls.Add($refreshBtn)
    $toolbar.Controls.Add($accentBtn)

    $terminal = New-Object System.Windows.Forms.Panel
    $terminal.Dock = "Fill"
    $terminal.Padding = New-Object System.Windows.Forms.Padding(20)
    $terminal.BackColor = [System.Drawing.Color]::FromArgb(12,12,12)

    $terminalText = New-Object System.Windows.Forms.RichTextBox
	$terminalText.Text = "TERMINAL PREVIEW LOADED"
    $terminalText.Dock = "Fill"
    $terminalText.BorderStyle = "None"
    $terminalText.ReadOnly = $true
	$terminalText.BackColor = [System.Drawing.Color]::Black
	$terminalText.ForeColor = [System.Drawing.Color]::Lime
    $terminalText.Font = New-Object System.Drawing.Font("Cascadia Code", 12)
    $terminalText.ScrollBars = "None"
	

    $terminal.Controls.Add($terminalText)

    if (Get-Command Register-PSPPreviewTarget -ErrorAction SilentlyContinue) {
        Register-PSPPreviewTarget `
            -Name "Terminal" `
            -TerminalText $terminalText `
            -Container $terminal
    }

    if (Get-Command Update-PSPTerminalPreview -ErrorAction SilentlyContinue) {
        Update-PSPTerminalPreview `
            -TerminalText $terminalText `
            -Container $terminal
    } else {
        $terminalText.Text = "Preview renderer not loaded."
    }

	$refreshBtn.Add_Click({

		if (Get-Command Refresh-PSPPreview -ErrorAction SilentlyContinue) {
			Refresh-PSPPreview
		} else {
			$terminalText.Text = "Refresh-PSPPreview function not loaded."
		}
	})

	$accentBtn.Add_Click({
		
		$terminalText.ForeColor = [System.Drawing.Color]::MediumPurple
		$terminalText.Text = "Accent applied.`r`n`r`nIf you can read this, the terminal text box works."
	})

    $panel.Controls.Add($terminal)
    $panel.Controls.Add($toolbar)

    $TabPage.Controls.Add($panel)
}