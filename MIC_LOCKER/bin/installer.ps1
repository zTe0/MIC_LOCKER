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
[System.Windows.Forms.Application]::EnableVisualStyles()

$currentFolder = $PSScriptRoot  # Gets the path of the script's current directory
New-Item -ItemType Directory -Force -Path $currentFolder | Out-Null

# Define shortcut files and their corresponding target paths
$shortcuts = @(
    @{ Name = "mic_killer.lnk"; TargetPath = "$currentFolder\hide_cmd_killer.vbs"; Icon = Join-Path $PSScriptRoot "icons8-block-microphone-70.ico" },
    @{ Name = "mic_level.lnk"; TargetPath = "$currentFolder\hide_cmd_custom.vbs"; Icon = Join-Path $PSScriptRoot "icons8-microphone-70.ico" },
    @{ Name = "mic_lock_default.lnk"; TargetPath = "$currentFolder\hide_cmd_default.vbs"; Icon = Join-Path $PSScriptRoot "icons8-microphone-70.ico" }
)

#  Set icons
$iconPath = @(
    Join-Path $PSScriptRoot/assets "i4.ico"
    # Join-Path $PSScriptRoot/icons "icons8-block-microphone-70.ico"
    # Join-Path $PSScriptRoot/icons "icons8-microphone-70.ico"
    # Join-Path $PSScriptRoot/icons "icons8-microphone-70.ico"
)

# Loop over each shortcut and update its target path and working directory
# $script:index = 0
foreach ($shortcut in $shortcuts) {
    # $script:index = ($script:index + 1)

    $shortcutSource = Join-Path $currentFolder $shortcut.Name  # Get the full path for the shortcut file

    $shell = New-Object -ComObject WScript.Shell
    $shortcutObject = $shell.CreateShortcut($shortcutSource)
    # Edit the shortcut (update target and working directory)
    $shortcutObject.TargetPath = $shortcut.TargetPath
    $shortcutObject.WorkingDirectory = $currentFolder
    $shortcutObject.IconLocation = $shortcut.Icon
    $shortcutObject.Save()
}

#################################################################################
# CHECKBOX for startup and start menu

# Add-Type -AssemblyName System.Windows.Forms

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Install Shortcuts'
$form.Size = New-Object System.Drawing.Size(300, 200)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = 'FixedDialog'  # Prevents resizing and dragging borders
$form.MaximizeBox = $false             # Disables maximize button

$form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($iconPath[0])

# Create Checkboxes for Start Menu and Startup Folder
$checkboxStartMenu = New-Object System.Windows.Forms.CheckBox
$checkboxStartMenu.Text = 'Add shortcuts to Start Menu'
$checkboxStartMenu.Checked = 1
$checkboxStartMenu.Location = New-Object System.Drawing.Point(20, 30)
$checkboxStartMenu.Width = 250

$checkboxStartup = New-Object System.Windows.Forms.CheckBox
$checkboxStartup.Text = 'Add shortcuts to Startup'
$checkboxStartup.Checked = 1
$checkboxStartup.Location = New-Object System.Drawing.Point(20, 60)
$checkboxStartup.Width = 250

# Create OK button
$buttonOk = New-Object System.Windows.Forms.Button
$buttonOk.Text = 'OK'
$buttonOk.Location = New-Object System.Drawing.Point(104, 100)
$buttonOk.DialogResult = [System.Windows.Forms.DialogResult]::OK

# Add controls to the form
$form.Controls.Add($checkboxStartMenu)
$form.Controls.Add($checkboxStartup)
$form.Controls.Add($buttonOk)
$form.Topmost = $true
# Show the form and wait for user response
$form.AcceptButton = $buttonOk
$result = $form.ShowDialog()

$form.KeyPreview = $true
$form.Add_KeyDown({
    if ($_.KeyCode -eq "Space") {
        $buttonOk.PerformClick()
    }
})


########################################################################################

# If the user clicked OK, check the states of the checkboxes
if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $addToStartMenu = $checkboxStartMenu.Checked
    $addToStartup = $checkboxStartup.Checked
    # Define Start Menu and Startup folder paths
    $startMenuFolder = "$env:AppData\Microsoft\Windows\Start Menu\Programs"
    $startupFolder = "$env:AppData\Microsoft\Windows\Start Menu\Programs\Startup"

    # Logic to handle the user's choices (add shortcuts, etc.)
    if ($addToStartMenu) {
        foreach ($shortcut in $shortcuts) {
            $shortcutSource = Join-Path $currentFolder $shortcut.Name  # Get the full path for the shortcut file
            if ($shortcut.Name -eq "mic_lock_default.lnk") {
                # Copy-Item $shortcutSource -Destination $startupFolder -Force
            } else {
                Copy-Item $shortcutSource -Destination $startMenuFolder -Force
            }
        }
    } else {
        $shortcutSource = Join-Path $startMenuFolder $shortcuts.Name[0]
        $shortcutSource1 = Join-Path $startMenuFolder $shortcuts.Name[1]
        if (Test-Path $shortcutSource) {
            Remove-Item $shortcutSource
            Remove-Item $shortcutSource1
        }
    }

    if ($addToStartup) {
        foreach ($shortcut in $shortcuts) {
            $shortcutSource = Join-Path $currentFolder $shortcut.Name  # Get the full path for the shortcut file
            if ($shortcut.Name -eq "mic_lock_default.lnk") {
                Copy-Item $shortcutSource -Destination $startupFolder -Force
            } else {
                # Copy-Item $shortcutSource -Destination $startMenuFolder -Force
            }
        }
    } else {
        $shortcutSource = Join-Path $startupFolder $shortcuts.Name[2]
        if (Test-Path $shortcutSource) {
            Remove-Item $shortcutSource
        }
    }
}

#  Copy - paste shortcuts to main folder
$parentFolder = [System.IO.Directory]::GetParent($currentFolder).FullName  # Get the parent folder of the source folder

# Copy the updated shortcuts to Start Menu and Startup folders
foreach ($shortcut in $shortcuts) {
    $shortcutSource = Join-Path $currentFolder $shortcut.Name  # Get the full path for the shortcut file

    # Copy each shortcut to upper folder
    # Define the new file path in the parent folder
    $destinationPath = Join-Path -Path $parentFolder -ChildPath $shortcut.Name
    
    # Move the file
    Copy-Item -Path $shortcutSource -Destination $destinationPath
}

Remove-Item -Path $destPath -Recurse -Force
