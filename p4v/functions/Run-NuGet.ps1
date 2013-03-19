function Run-NuGet {
    param(
        [string]$command,
        [string]$source,

        [parameter()]
        [string]$PackageName,

        [parameter()]
        [string]$Version,
        
        [bool]$global
    )

    #Building arguments string
    $arguments = "$command "

    switch($command)
    {
        install
        {
            if($PackageName -eq ''){
                Write-Debug "[ERROR] PackageName not specified, aborting function"
                return
            }
            
            $arguments += "$PackageName -OutputDirectory "

            if ($global) {
                $arguments += "GLOBALPATH "
            }
            else {
                $arguments += "$localPath "
            }
        }
        update
        {
            $arguments += "-RepositoryPath "

            if ($global) {
                $arguments += "GLOBALPATH "
            }
            else {
                $arguments += "LOCALPATH "
            }
        }
        list
        {
            if ($PackageName -ne '') {$arguments += "$PackageName "}
        }
        pack
        {
            $arguments += "-OutputDirectory .\package"
        }
        default
        {
            Write-Debug "[ERROR] Command not specified, aborting function"
            return
        }
    }

    if($Version -ne '') {$arguments += "-Version $Version "}
    if ($source -ne '') {$arguments += "-Source $source "}

    #Running NuGet in separate process
    Write-Debug "Running NuGet with following arguments: $arguments"

    $process = New-Object system.Diagnostics.Process
    $process.StartInfo = new-object System.Diagnostics.ProcessStartInfo($nugetExe, $arguments)
    $process.StartInfo.RedirectStandardOutput = $true
    $process.StartInfo.RedirectStandardError = $true
    $process.StartInfo.UseShellExecute = $false
    $process.StartInfo.WorkingDirectory = $invocationDir

    $process.Start() | Out-Null
    $process.WaitForExit()

    $nugetOutput = $process.StandardOutput.ReadToEnd()
    $errors = $process.StandardError.ReadToEnd()

    foreach ($line in $nugetOutput) {
        if ($line -ne $null) {
            Write-Debug $line;
        }
    }
    
    if ($errors -ne '') {
        Write-Host $errors
    }

    if (($nugetOutput -eq '' -or $nugetOutput -eq $null) -and ($errors -eq '' -or $errors -eq $null)) {
        $noExecution = 'Execution of NuGet not detected. Please make sure you have .NET Framework 4.0 installed and are passing arguments to the install command.'
        Throw $noExecution
    }
}