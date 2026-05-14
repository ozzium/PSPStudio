Register-PSPTab -Name "Appearance Studio" -Render {
    param($TabPage)

    $panel = New-Object System.Windows.Forms.Panel
    $panel.Dock = "Fill"

    $toolbar = New-Object System.Windows.Forms.FlowLayoutPanel
    $toolbar.Dock = "Top"
    $toolbar.Height = 50
    $toolbar.Padding = New-Object System.Windows.Forms.Padding(8,8,8,8)

    $browseBtn = New-Object System.Windows.Forms.Button
    $browseBtn.Text = "Choose Background"
    $browseBtn.Width = 180

    $saveBtn = New-Object System.Windows.Forms.Button
    $saveBtn.Text = "Save Appearance"
    $saveBtn.Width = 160

    $pathLabel = New-Object System.Windows.Forms.Label
    $pathLabel.AutoSize = $true
    $pathLabel.Padding = New-Object System.Windows.Forms.Padding(10,8,0,0)
    $pathLabel.Text = "No background selected"

   $preview = New-Object System.Windows.Forms.PictureBox
	$preview.Dock = "Fill"
	$preview.BackColor = [System.Drawing.Color]::FromArgb(30,30,30)
	$preview.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom

	$browseBtn.Tag = $preview

    function Set-PreviewImage {
        param(
            [System.Windows.Forms.PictureBox]$PictureBox,
            [string]$Path
        )

        if (-not (Test-Path $Path)) { return }

        try {
            if ($PictureBox.Image) {
                $old = $PictureBox.Image
                $PictureBox.Image = $null
                $old.Dispose()
            }

            $bytes = [System.IO.File]::ReadAllBytes($Path)
            $ms = New-Object System.IO.MemoryStream(,$bytes)
            $img = [System.Drawing.Image]::FromStream($ms)
            $bmp = New-Object System.Drawing.Bitmap($img)

            $img.Dispose()
            $ms.Dispose()

            $PictureBox.Image = $bmp
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show(
                $_.Exception.Message,
                "Image Load Failed"
            ) | Out-Null
        }
    }

$browseBtn.Add_Click({

    param($sender, $eventArgs)

    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.Filter = "Images|*.png;*.jpg;*.jpeg;*.bmp"

    if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {

        $selected = $dialog.FileName

        if (-not ($Global:PSPConfig.PSObject.Properties.Name -contains "BackgroundImage")) {
            $Global:PSPConfig | Add-Member -NotePropertyName "BackgroundImage" -NotePropertyValue ""
        }

        $Global:PSPConfig.BackgroundImage = $selected
        $pathLabel.Text = $selected

        try {

            $pictureBox = [System.Windows.Forms.PictureBox]$sender.Tag

            if ($null -eq $pictureBox) {
                throw "Preview PictureBox was not found."
            }

            if ($pictureBox.Image) {
                $old = $pictureBox.Image
                $pictureBox.Image = $null
                $old.Dispose()
            }

            $pictureBox.Image = [System.Drawing.Bitmap]::FromFile($selected)
            $pictureBox.Refresh()
        }
        catch {

            [System.Windows.Forms.MessageBox]::Show(
                $_.Exception.Message,
                "Image Preview Failed"
            ) | Out-Null
        }
    }
})

    $saveBtn.Add_Click({
        Save-PSPConfig $Global:PSPConfig
		Refresh-PSPPreview

        [System.Windows.Forms.MessageBox]::Show(
            "Appearance settings saved.",
            "PSPStudio"
        ) | Out-Null
    })

    if ($Global:PSPConfig.BackgroundImage -and (Test-Path $Global:PSPConfig.BackgroundImage)) {
        $pathLabel.Text = $Global:PSPConfig.BackgroundImage
        Set-PreviewImage -PictureBox $preview -Path $Global:PSPConfig.BackgroundImage
    }

    $toolbar.Controls.Add($browseBtn)
    $toolbar.Controls.Add($saveBtn)
    $toolbar.Controls.Add($pathLabel)

    $panel.Controls.Add($preview)
    $panel.Controls.Add($toolbar)

    $TabPage.Controls.Add($panel)
}