function P4V-Pack {
    $packageDir = Join-Path $invocationDir "package"
    Remove-Item $packageDir\*
    Run-NuGet pack
    
    $archiveName = Get-ChildItem $packageDir -Filter *.nupkg -Name
    $archiveName = $archiveName.Replace(".nupkg", "")
    $archiveName += ".zip" 
    
    Run-7z pack $archiveName
}