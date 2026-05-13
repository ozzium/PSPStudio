function Start-PSPStudio {

    $form = New-Object System.Windows.Forms.Form

   $form.Text = "PSPStudio"
	$form.Width = $Global:PSPConfig.WindowWidth
	$form.Height = $Global:PSPConfig.WindowHeight
	$form.StartPosition = "CenterScreen"
	$form.MinimumSize = New-Object System.Drawing.Size(900, 600)
	$form.Size = New-Object System.Drawing.Size(1200, 800)

    $tabs = New-Object System.Windows.Forms.TabControl
    $tabs.Dock = "Fill"

    $form.Controls.Add($tabs)

    $Global:PSPTabControl = $tabs
    $Global:PSPMainForm   = $form

    # Build registered tabs
    foreach ($tabDef in $Global:PSPTabs) {

        $tabPage = New-Object System.Windows.Forms.TabPage
        $tabPage.Text = $tabDef.Name

        try {
            & $tabDef.Render $tabPage
        }
        catch {
            Write-PSPLog "Failed rendering tab: $($tabDef.Name)" "ERROR"
        }

        $tabs.TabPages.Add($tabPage)
    }

    Write-PSPLog "PSPStudio launched."

    [void]$form.ShowDialog()
}