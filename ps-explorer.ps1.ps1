if (!$args[0]){
   Write-Output "Usage : ps-explorer.ps1 <regex-dlls>"
   Write-Output "Example : ps-explorer.ps1 'KERNEL32\.DLL|NTDLL\.DLL'"
   exit 
}

# Specify DLL names using a regular expression
$dllRegex = $args[0]

$tasklistOutput = tasklist /m /fo csv | ConvertFrom-Csv

# None of the specified DLLs were loaded in the following processes :

$results = foreach ($process in $tasklistOutput) {
    $processName = $process."Image Name" + $process."Nom de l'image"
    $processId = $process.PID
    $modules = $process.Modules
    if ($modules -notmatch $dllRegex) {
        $executablePath = Get-Process -Id $processId | Select-Object -ExpandProperty Path

        if ($executablePath) {
            [PSCustomObject]@{
                PID         = $processId
                ProcessName = $processName
                Path        = $executablePath
  		Comments    = "None of the specified DLLs were loaded :  $dllRegex" 
            }
        }
    }
}

# Display the results
$results