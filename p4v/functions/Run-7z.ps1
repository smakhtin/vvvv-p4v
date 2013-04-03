function Run-7z {
    param(
        [string]$command,
        [string]$filename
    )

    $arguments = ""
    $packArguments = "a -tzip .\package\$filename .\modules .\effects .\plugins -mx9"
    $unpackArguments = ""
    
    switch ($command)
    {
        pack {$arguments = $packArguments}
        unpack {$arguments = "$unpackArguments"}
        default {
            Write-Debug "Specify command: pack, unpack"
            return
        }
    }

    #Running NuGet in separate process
    Write-Debug "Running 7z with following arguments: $arguments"

    $process = New-Object system.Diagnostics.Process
    $process.StartInfo = new-object System.Diagnostics.ProcessStartInfo($7zExe, $arguments)
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