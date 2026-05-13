Register-PSPTab -Name "Profile Editor" -Render {

    param($TabPage)

    $panel = New-Object System.Windows.Forms.Panel
    $panel.Dock = "Fill"

    $toolbar = New-Object System.Windows.Forms.FlowLayoutPanel
    $toolbar.Dock = "Top"
    $toolbar.Height = 40
    $toolbar.Padding = "8,5,5,5"

    $saveBtn = New-Object System.Windows.Forms.Button
    $saveBtn.Text = "Save"
    $saveBtn.Width = 100

    $reloadBtn = New-Object System.Windows.Forms.Button
    $reloadBtn.Text = "Reload"
    $reloadBtn.Width = 100

    $editor = New-Object System.Windows.Forms.RichTextBox
    $editor.Dock = "Fill"
    $editor.Font = New-Object System.Drawing.Font("Consolas", 11)
    $editor.BackColor = [System.Drawing.Color]::FromArgb(30,30,30)
    $editor.ForeColor = [System.Drawing.Color]::FromArgb(220,220,220)
    $editor.BorderStyle = "None"
    $editor.AcceptsTab = $true
    $editor.WordWrap = $false
    $editor.Multiline = $true
    $editor.ScrollBars = "Both"
    $editor.DetectUrls = $false

    if (Test-Path $Global:PSPProfilePath) {
        $editor.Text = [System.IO.File]::ReadAllText($Global:PSPProfilePath)
    }

    # Store the editor directly on the buttons so the click handler uses the right object
    $saveBtn.Tag = $editor
    $reloadBtn.Tag = $editor

    $saveBtn.Add_Click({
        param($sender, $eventArgs)

        try {
            $box = [System.Windows.Forms.RichTextBox]$sender.Tag

            if ($null -eq $box) {
                throw "Editor control was not found."
            }

            $dir = Split-Path -Parent $Global:PSPProfilePath
            if (-not (Test-Path $dir)) {
                New-Item -ItemType Directory -Path $dir -Force | Out-Null
            }

            # Backup before writing, so we never accidentally destroy the sandbox file
            if (Test-Path $Global:PSPProfilePath) {
                Copy-Item $Global:PSPProfilePath "$Global:PSPProfilePath.bak" -Force
            }

            $content = [string]$box.Text

            $tmp = "$Global:PSPProfilePath.tmp"
            [System.IO.File]::WriteAllText($tmp, $content, [System.Text.Encoding]::UTF8)
            Move-Item $tmp $Global:PSPProfilePath -Force

            Write-PSPLog "Sandbox profile saved."

            [System.Windows.Forms.MessageBox]::Show(
                "Profile saved.",
                "PSPStudio"
            ) | Out-Null
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show(
                $_.Exception.Message,
                "Save Failed"
            ) | Out-Null
        }
    })

    $reloadBtn.Add_Click({
        param($sender, $eventArgs)

        $box = [System.Windows.Forms.RichTextBox]$sender.Tag

        if ($box -and (Test-Path $Global:PSPProfilePath)) {
            $box.Text = [System.IO.File]::ReadAllText($Global:PSPProfilePath)
        }
    })

    $toolbar.Controls.Add($saveBtn)
    $toolbar.Controls.Add($reloadBtn)

    $panel.Controls.Add($editor)
    $panel.Controls.Add($toolbar)

    $TabPage.Controls.Add($panel)
}