    function Get-FileName($initialDirectory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = "Microsoft Access Databases | *.accdb | MDB | *.mdb"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
}


function compactDatabaseFile($sourceFilename, $destinationFileName)
{

# Record current file datetime stamp
    $lastWriteTime = Get-ItemPropertyValue -Path $sourceFilename -Name LastWriteTime 
    $CreationTime = Get-ItemPropertyValue -Path $sourceFilename -Name CreationTime
    $LastAccessTime = Get-ItemPropertyValue -Path $sourceFilename -Name LastAccessTime

    $application =  New-Object -ComObject Access.Application

    Write-Host $($(Get-Date).ToString() + ": Starting compacting of $sourceFilename to $destinationFileName")  | tee-object -filepath $logfilename -Append
    try {
            $application.CompactRepair($sourceFilename,$destinationFileName, $true)
    } catch {
    "    Exception: ($_.Exception).ToString()"
            Write-Host $($(Get-Date).ToString() + ": Error compacting of $sourceFilename to $destinationFileName")  | tee-object -filepath $logfilename -Append
            $DBCompactFailure = $True
    }

    $application.Quit()

    if (test-path $destinationFileName) {
        Write-Host $($(Get-Date).ToString() + ": Finished compacting of $sourceFilename to $destinationFileName")
        Set-ItemProperty -path $destinationFileName -name LastWriteTime -value $LastWriteTime
        Set-ItemProperty -path $destinationFileName -name CreationTime -value $CreationTime
        Set-ItemProperty -path $destinationFileName -name LastAccessTime -value $LastAccessTime
    } 
    
    $basename = ([io.fileinfo]$sourceFileName).basename
    $dirname =  ([io.fileinfo]$sourceFileName).DirectoryName
    $dblogfilename = $dirname + "\" + $basename + ".log"
    if (test-path $dblogfilename) {
        Write-Host $($(Get-Date).ToString() + ": Internal Errors compacting of $sourceFilename to $destinationFileName") | tee-object -filepath $logfilename -Append
        $DBCompactFailure = $True
    }

    # if no error and savings > 5% - replace file.
    if (test-path $sourcefilename) {
        Set-ItemProperty -path $sourceFilename -name LastWriteTime -value $LastWriteTime
        Set-ItemProperty -path $sourceFilename -name CreationTime -value $CreationTime
        Set-ItemProperty -path $sourceFilename -name LastAccessTime -value $LastAccessTime
        if (-not($DBCompactFailure)) {
            Start-BitsTransfer -Source $destinationFileName -Destination $sourcefilename -Description "Backup" -DisplayName "Test-$SourceFileName"
            write-host "Copy-item $destinationFileName $sourceFileName"
            
        }
    }
    
}

function driver($sourceDirectory, $newDestinationDirectory, $filePatterns = @("*.mdb","backup_backup*.accdb"))
{
    Write-Host "Checking Destination Directory $newDestinationDirectory exists."  | tee-object -filepath $logfilename -Append
    if (Test-Path $newDestinationDirectory) {
        Write-Host "Destination Directory $newDestinationDirectory exists.  "  | tee-object -filepath $logfilename -Append
    } else {
        mkdir $newDestinationDirectory | Out-Null
        #Exit
    }

    Write-Host "Checking Source Directory $SourceDirectory exists." | tee-object -filepath $logfilename -Append
    if (!$(Test-Path $sourceDirectory)) {
        Write-Host "SourceDirectory $sourceDirectory not found.  Exiting without doing anything."  | tee-object -filepath $logfilename -Append
        Exit
    }

    $sourceFileName = Get-Filename($SourceDirectory)
    if (!$(Test-Path $sourceFileName)) {
        Write-Host "SourceFile $sourceFileName not found.  Exiting without doing anything."  | tee-object -filepath $logfilename -Append
        Exit
    }
    $destinationFileName = $($newDestinationDirectory + "\" + $(Split-Path $sourceFileName -leaf));
    write-host "Calling Compress function with $sourceFileName"
    compactDatabaseFile $sourceFileName $destinationFilename
    
}
Import-Module BitsTransfer
$logfilename = "c:\temp\dbCompactLog.log"
driver -sourceDirectory "c:\temp\" -newDestinationDirectory "c:\temp\3"