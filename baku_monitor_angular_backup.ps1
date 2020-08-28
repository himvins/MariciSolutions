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
$baseFolderForChange = "C:\Users\HimanshuV\HimanshuVinchhi\Utilities\Practice\angular-demo"
$baseFolderForBackup =  "C:\Users\HimanshuV\HimanshuVinchhi\Utilities\Practice\Backup\"
#base folder for backup 

while($true){
 $date = Get-Date -Format "dd_MM"
$path = $baseFolderForBackup + $date

if(!($path | Test-Path)) {
   # create today's folder if not exists already. 
   new-item $path -itemtype directory
}


$time = Get-Date -Format "HH_mm"
#Running this two times to make sure all desired files are copied. 
Get-ChildItem -Path $baseFolderForChange -exclude node_modules | Copy-Item  -Destination $path"\"$time -Recurse -Force
Get-ChildItem -Path $baseFolderForChange -exclude node_modules | Copy-Item  -Destination $path"\"$time -Recurse -Force

Compress-Archive -Path $path"\"$time"\*" -DestinationPath $path"\"$time"\"trstrg.zip -Force

Copy-Item $path"\"$time"\"trstrg.zip  -Destination "C:\Users\HimanshuV\HimanshuVinchhi\Utilities\Practice\Backup\LatestZipForUpload\"


Read-Host -Prompt "Press Enter to take the backup now.."  
}
