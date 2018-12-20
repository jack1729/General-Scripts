#EULA: ?
#Load required assemblies
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.windows.Forms")

#Drawing Forms and controls
$Form_HelloWorld = New-Object System.Windows.Forms.Form

$Form_HelloWorld.Text = "Hello World Title!"
$Form_HelloWorld.Size = New-Object System.Drawing.Size(272,160)
$Form_HelloWorld.FormBorderStyle = "FixedDialog"
$Form_HelloWorld.TopMost = $true
$Form_HelloWorld.ControlBox = $true
$Form_HelloWorld.StartPosition = "CenterScreen"
$Form_HelloWorld.font = "Segoe UI"

#Add Label
$label_HelloWorld = New-Object System.Windows.Forms.Label
$label_HelloWorld.location = New-Object System.Drawing.Size(8,8)
$label_HelloWorld.Size = New-Object System.Drawing.Size(240,32)
$label_HelloWorld.TextAlign = "MiddleCenter"
$label_HelloWorld.Text = "Hello World Label"

$button_ClickMe = New-Object System.Windows.forms.Button
# Size(x,y) - x is over from left, y is down from top
$button_ClickMe.location = New-Object System.Drawing.Size(8,80)
$button_ClickMe.Size = New-Object System.Drawing.Size(240,32)
$button_ClickMe.TextAlign = "MiddleCenter"
$button_ClickMe.Text = "Click Me"
$button_ClickMe.Add_Click({
    $button_ClickMe.Text = "Clicked"
    start-process calc.exe
})

#add label control to form
$Form_HelloWorld.Controls.Add($label_HelloWorld)
$Form_HelloWorld.Controls.Add($button_ClickMe)

#Show Form
$Form_HelloWorld.Add_Shown({$Form_HelloWorld.Activate()})
[void] $form_HelloWorld.ShowDialog()