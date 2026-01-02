#####################################################################################
####################### Author: Matteo Luciardello Lecardi ##########################
#####################################################################################

# Minimize cmd window
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();
}
"@

# Add-Type @"
# using System;
# using System.Runtime.InteropServices;

# public class DPI {
#     [DllImport("user32.dll")]
#     public static extern bool SetProcessDPIAware();
# }
# "@
# [DPI]::SetProcessDPIAware()

$consolePtr = [Win32]::GetConsoleWindow()
if ($consolePtr -ne [IntPtr]::Zero) {
    # SW_MINIMIZE = 6
    [Win32]::ShowWindow($consolePtr, 6)
}

####################################################################################

$zipPath = "$PSScriptRoot/assets.7z"
$destPath = "$PSScriptRoot/assets"
$asset = "XB"

# Ensure the folder exists
New-Item -Path $destPath -ItemType Directory -Force

# Extract using 7z (must be installed or bundled with your installer)
& "C:\Program Files\7-Zip\7z.exe" x $zipPath -p"$asset" -o"$destPath" -y

####################################################################################

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$form = New-Object Windows.Forms.Form
$form.Text = "MIC LEVEL"
$form.Size = New-Object Drawing.Size(400,150)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = 'FixedDialog'  # Prevents resizing and dragging borders
$form.MaximizeBox = $false             # Disables maximize button
# $form.MinimizeBox = $false             # Optional: disable minimize
$form.AutoScaleMode = "Dpi"

#  Set icon
$iconPath = @(
    Join-Path $PSScriptRoot/assets "i1.ico"
    Join-Path $PSScriptRoot/assets "i2.ico"
    Join-Path $PSScriptRoot/assets "i3.ico"
    Join-Path $PSScriptRoot/assets "i4.ico"
#     Join-Path $PSScriptRoot/assets "i5.ico"
#     Join-Path $PSScriptRoot/assets "i6.ico"
#     Join-Path $PSScriptRoot/assets "i7.ico"
)

# Function to safely load image
function Load-Image($path) {
    $img = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
    return $img
}

if (Test-Path $iconPath[0]) {
    $script:currentIndex = 0
    $form.Icon = Load-Image $iconPath[2]
    $icon = Load-Image $iconPath[$script:currentIndex]
    $pictureBox = New-Object Windows.Forms.PictureBox
    $pictureBox.Image = $icon #.ToBitmap()
    # $pictureBox.Size = New-Object Drawing.Size(40, 40)
    $pictureBox.Width = 40
    $pictureBox.Height = 40
    # $pictureBox.SizeMode = "Zoom"  # Avoid stretching, preserves aspect ratio
    $pictureBox.Location = New-Object Drawing.Point(10, 20)

    # $scaledBitmap = New-Object System.Drawing.Bitmap($pictureBox.Width, $pictureBox.Height)
    # $graphics = [System.Drawing.Graphics]::FromImage($scaledBitmap)
    # $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    # $graphics.DrawImage($icon, 0, 0, $scaledBitmap.Width, $scaledBitmap.Height)
    # $graphics.Dispose()
    # $pictureBox.Image = $scaledBitmap

    $form.Controls.Add($pictureBox)

}
# On click, change the image
$pictureBox.Add_Click({
    $pictureBox.Image.Dispose()
    $script:currentIndex = ($script:currentIndex + 1) % $iconPath.Count
    $icon = Load-Image $iconPath[$script:currentIndex]
    $pictureBox.Image = $icon.ToBitmap()
})


$slider = New-Object Windows.Forms.TrackBar
$slider.Minimum = 0
$slider.Maximum = 100
$slider.Value = Get-Content -Path "$PSScriptRoot\current_volume.txt"
$slider.TickFrequency = 10
$slider.SmallChange = 1
$slider.LargeChange = 10
$slider.TickStyle = "BottomRight"
$slider.Location = New-Object Drawing.Point(50,20)
$slider.Width = 300

$valueLabel = New-Object Windows.Forms.Label
$valueLabel.Location = New-Object Drawing.Point(350,25)
$valueLabel.Size = New-Object Drawing.Size(40,20)
$valueLabel.Text = $slider.Value

$slider.Add_ValueChanged({
    $valueLabel.Text = $slider.Value
})

# Draw labels below ticks
$labelY = 55
$labelX_manual = @{
    0   = 58     # X position for value 0
    10  = 82
    20  = 110
    30  = 137
    40  = 164
    50  = 192
    60  = 219
    70  = 246
    80  = 273
    90  = 301
    100 = 325
}
for ($i = 0; $i -le 10; $i++) {
    $value = $i * 10
    $lbl = New-Object Windows.Forms.Label
    $lbl.Text = "$value"
    $lbl.AutoSize = $true
    # $spacing = [math]::Floor($slider.Width / 11)
    # $labelX = 58 + ($i * $spacing) 
    $lbl.Location = New-Object Drawing.Point($labelX_manual[$value], $labelY)
    $form.Controls.Add($lbl)
}

# Variable to track if closed by X
$script:closedByX = $true

# OK Button
$okBtn = New-Object Windows.Forms.Button
$okBtn.Text = "OK"
$okBtn.Location = New-Object Drawing.Point(150,80)
$okBtn.Add_Click({
    Set-Content -Path "$PSScriptRoot\volume.txt" -Value $slider.Value
    $form.Close()
    $script:closedByX = $false
    # [System.Windows.Forms.MessageBox]::Show("User closed window with OK")
})
$form.AcceptButton = $okBtn
# $form.DialogResult = [System.Windows.Forms.DialogResult]::OK

$form.KeyPreview = $true
$form.Add_KeyDown({
    if ($_.KeyCode -eq "Space") {
        $okBtn.PerformClick()
    }
})

$form.Controls.Add($slider)
$form.Controls.Add($valueLabel)
$form.Controls.Add($okBtn)

$form.Topmost = $true

# Show the form modally and get DialogResult
[void]$form.ShowDialog()

# Check if user pressed OK or closed the window
if ($script:closedByX) {
    $slider.Value = Get-Content -Path "$PSScriptRoot\current_volume.txt"
    Set-Content -Path "$PSScriptRoot\volume.txt" -Value $slider.Value
    # [System.Windows.Forms.MessageBox]::Show("User closed window with X")
}

Remove-Item -Path $destPath -Recurse -Force
