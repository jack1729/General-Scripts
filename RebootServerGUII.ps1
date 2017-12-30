Function BuildSched($sname,$reboottime) {
    if(Test-WSMan -ComputerName "wpsusa02.upgf.com" -EA 0) {
        write-host $sname
        write-host $reboottime
        Invoke-Command -computername "WPSUSA02" {
            param($sname)
            $settings = New-ScheduledTaskSettingsSet -Hidden
            $trigger = New-ScheduledTaskTrigger -Weekly -at 9am -DaysOfWeek Sunday
            $action = New-ScheduledTaskAction -Execute "c:\windows\system32\rebootsrv.bat $sname"
            Register-ScheduledTask -trigger $trigger -TaskName $sname -settings $settings -TaskPath 'UPSReboots' -Action $action -User 'richmond\nbch404' -Password 'Wegr8c0m$'
        } -argumentList $sname
    } else {
        "WPSUSA02 not available"
        Exit
    }
}
#From: https://poshgui.com/#
Add-Type -AssemblyName System.Windows.Forms
$version = 0.99

$form_rebootserver = New-Object system.Windows.Forms.Form 
$form_rebootserver.Text = "Reboot Server Script v$version"
$form_rebootserver.TopMost = $true
$form_rebootserver.Width = 361
$form_rebootserver.Height = 223
$form_rebootserver.KeyPreview = $True
$form_rebootserver.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
    {$objForm.Close()}})
$form_rebootserver.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$objForm.Close()}})


$textBox_ServerName = New-Object system.windows.Forms.TextBox 
$textBox_ServerName.Text = "ServerName"
$textBox_ServerName.Width = 100
$textBox_ServerName.Height = 10
$textBox_ServerName.location = new-object system.drawing.point(103,20)
$textBox_ServerName.Font = "Microsoft Sans Serif,10"
$form_rebootserver.controls.Add($textBox_ServerName) 

$label_ServerName = New-Object system.windows.Forms.Label 
$label_ServerName.Text = "Server Name: "
$label_ServerName.AutoSize = $true
$label_ServerName.Width = 25
$label_ServerName.Height = 10
$label_ServerName.location = new-object system.drawing.point(10,20)
$label_ServerName.Font = "Microsoft Sans Serif,10"
$form_rebootserver.controls.Add($label_ServerName) 

$label_time = New-Object system.windows.Forms.Label 
$label_time.Text = "Time (00:00): "
$label_time.AutoSize = $true
$label_time.Width = 25
$label_time.Height = 10
$label_time.location = new-object system.drawing.point(10,43)
$label_time.Font = "Microsoft Sans Serif,10"
$form_rebootserver.controls.Add($label_time) 

$textBox_time = New-Object system.windows.Forms.TextBox 
$textBox_time.Text = "06:00"
$textBox_time.Width = 100
$textBox_time.Height = 43
$textBox_time.location = new-object system.drawing.point(103,45)
$textBox_time.Font = "Microsoft Sans Serif,10"
$form_rebootserver.controls.Add($textBox_time) 

$label_day = New-Object system.windows.Forms.Label 
$label_day.Text = "Day: "
$label_day.AutoSize = $true
$label_day.Width = 25
$label_day.Height = 10
$label_day.location = new-object system.drawing.point(11,69)
$label_day.Font = "Microsoft Sans Serif,10"
$form_rebootserver.controls.Add($label_day) 

$textBox_Day = New-Object system.windows.Forms.TextBox 
$textBox_Day.Text = "Sunday"
$textBox_Day.Width = 100
$textBox_Day.Height = 20
$textBox_Day.location = new-object system.drawing.point(102,68)
$textBox_Day.Font = "Microsoft Sans Serif,10"
$form_rebootserver.controls.Add($textBox_Day) 

$button_ScheduleTask = New-Object system.windows.Forms.Button 
$button_ScheduleTask.Text = "Schedule Task"
$button_ScheduleTask.Width = 80
$button_ScheduleTask.Height = 40
$button_ScheduleTask.location = new-object system.drawing.point(110,109)
$button_ScheduleTask.Font = "Microsoft Sans Serif,10"
$button_ScheduleTask.Add_Click({
    #$button_ScheduleTask.Text "Scheduling"textBox_ServerName
    BuildSched $textBox_ServerName.Text $textBox_time.text
    #$button_ScheduleTask.Text "Scheduled!"
})
$form_rebootserver.controls.Add($button_ScheduleTask) 

$buttonExit = New-Object system.windows.Forms.Button 
$buttonExit.Text = "Exit"
$buttonExit.Width = 60
$buttonExit.Height = 30
$buttonExit.location = new-object system.drawing.point(8,146)
$buttonExit.Font = "Microsoft Sans Serif,10"
$buttonExit.Add_Click({
    $form_rebootserver.Close()
})
$form_rebootserver.controls.Add($buttonExit) 

[void]$form_rebootserver.ShowDialog() 

$form_rebootserver.Dispose() 
