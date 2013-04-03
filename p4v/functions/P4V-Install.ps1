function P4V-Install {
    param(
        [string] $packageName,
        [string] $source = "",
        [string] $version = ""
    )

    Run-Nuget "install" -PackageName $packageName -Source $source -Version $version

    if ($global) {
        $packagesDir = $globalPath
    }
    else {
        $packagesDir = $localPath
    }

    Write-Debug $global
    Write-Debug $packagesDir

    $folderName = Get-ChildItem $packagesDir -Filter "$packageName*" -Name
    $installationDir = Join-Path $packagesDir $folderName
    Write-Host $installationDir
    $toolsFolder = Join-Path $installationDir "\tools"
    Write-Host $toolsFolder
    $script = Join-Path $toolsFolder "p4vinstall.ps1"

    Invoke-Expression $script
}