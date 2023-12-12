$ErrorActionPreference = 'SilentlyContinue'
# Define the relative path to the executable that detect the presence of the module
$executableRelativePath = ".\scout.exe"

# Define the relative root path where you want to start the search
$rootPath = $args[0]
# $rootPath = "C:\Program Files"

# Name of the module to look for 
# $dll = "InProcessClient64.dll"  
# Specify DLL names using a regular expression
$dllList = $args[1]

# Get the directory where the script is located
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
# Convert to an absolute path
$executablePath = Join-Path -Path $scriptDirectory -ChildPath $executableRelativePath

Write-Host "Fetching available directories ......"
# Get all subfolders recursively (we reduce the max depth for testing purpose)
$subfolders = Get-ChildItem $rootPath,$rootPath\*,$rootPath\*\*,$rootPath\*\*\* -Directory -Exclude Windows,WindowsApps,TEMP -Force

# Write-Host "Executing : $executablePath"
# Write-Host "Into : $rootPath"
Write-Host "The scouts are looking for an excluded folder ..... "

# Copy the executable to each subfolder and execute it
$results = foreach ($subfolder in $subfolders) {
    $destinationPath = Join-Path -Path $subfolder.FullName -ChildPath "o0o.exe"

    # Check if the script has the right to write in the folder
    if (Test-Path -Path $subfolder.FullName -IsValid) {
        # Copy the executable
        Copy-Item -Path $executablePath -Destination $destinationPath -Force
        
        # Execute the copied executable and capture the output
        $output = Start-Process -FilePath $destinationPath -ArgumentList $dllList -NoNewWindow -Wait -PassThru
        
        # Check the return code of the process
        if ($output.ExitCode -eq 1) {
	    [PSCustomObject]@{
                Path         = $destinationPath
  		Comments    = "None of the specified DLLs were loaded :  $dllRegex" 
            }
	    Remove-Item -Path $destinationPath -Force
            exit
        } 

        # Remove the copied executable after execution
        Remove-Item -Path $destinationPath -Force
    }
}

$results
