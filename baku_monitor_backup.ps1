# Gather command meta data from the original Cmdlet (in this case, Test-Path)
$TestPathCmd = Get-Command Test-Path
$TestPathCmdMetaData = New-Object System.Management.Automation.CommandMetadata $TestPathCmd

# Use the static ProxyCommand.GetParamBlock method to copy 
# Test-Path's param block and CmdletBinding attribute
$Binding = [System.Management.Automation.ProxyCommand]::GetCmdletBindingAttribute($TestPathCmdMetaData)
$Params  = [System.Management.Automation.ProxyCommand]::GetParamBlock($TestPathCmdMetaData)

# Create wrapper for the command that proxies the parameters to Test-Path 
# using @PSBoundParameters, and negates any output with -not
$WrappedCommand = { 
    try { -not (Test-Path @PSBoundParameters) } catch { throw $_ }
}

# define your new function using the details above
$Function:notexists = '{0}param({1}) {2}' -f $Binding,$Params,$WrappedCommand


#base folder for change
$baseFolderForChange = "C:\Users\HimanshuV\Documents\change"
$baseFolderForBackup =  "C:\Users\HimanshuV\Documents\backup\"
#base folder for backup 


while($true){
 $date = Get-Date -Format "dd_MM"
$path = $baseFolderForBackup + $date

if(!($path | Test-Path)) {
   # create today's folder if not exists already. 
   new-item $path -itemtype directory
}


$time = Get-Date -Format "HH_mm"

Copy-Item $baseFolderForChange  -Destination $path"\"$time -Recurse

Compress-Archive -Path $path"\"$time"\trstrg\*" -DestinationPath $path"\"$time"\trstrg\"trstrg.zip

Copy-Item $path"\"$time"\trstrg\"trstrg.zip  -Destination "C:\Users\HimanshuV\Documents\backup\LatestBackupZipToUpload\"


Read-Host -Prompt "Press Enter to take the backup now.."  
}