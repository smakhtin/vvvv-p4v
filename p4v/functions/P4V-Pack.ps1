function P4V-Pack {
    $nuspecPath = Get-ChildItem $packageDir -Filter *.nuspec -Name
    $nuspecPath = Join-Path $invocationDir $nuspecPath

    Write-Debug $nuspecPath

    $nuspec = [xml](Get-Content $nuspecPath)
    $packageName = $nuspec.package.metadata.id
    $packageVersion = $nuspec.package.metadata.version
    
    $archiveName = $packageName + '.' + $packageVersion + ".zip"
    
    $packageDir = Join-Path $invocationDir "package"

    if (-not (Test-Path $packageDir)) {
        New-Item -Path $packageDir -ItemType directory
    }
    
    Remove-Item $packageDir\*
    
    Run-NuGet pack
    
    Run-7z pack $archiveName
}