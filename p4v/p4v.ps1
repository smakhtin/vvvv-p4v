param(
    [string]$command,
    [string]$packageName,
    
    [parameter()]
    [string]$Version,

    [switch]$global
)

$p4vDir = (Split-Path -parent $MyInvocation.MyCommand.Definition)
#Write-Debug $PSCommandPath

$cacheDir = Join-Path $env:AppData "p4v\cache"
$vvvv45Dir = Split-Path -parent $p4vDir
$invocationDir = Get-Location
$nugetExe = Join-Path $p4vDir "bin\NuGet.exe"
$7zExe = Join-Path $p4vDir "bin\7za.exe"
$source = "http://www.myget.org/F/p4v/"
$folderName = "packages"

$localPath = Join-Path $pwd $folderName
$globalPath = Join-Path $vvvv45Dir $folderName

#Loading external functions
Resolve-Path $p4vDir\functions\*.ps1 | 
    ? { -not ($_.ProviderPath.Contains(".Tests.")) } |
    % { . $_.ProviderPath }

if (-not (Test-Path $env:AppData\p4v\cache)) {
    New-Item -Path $env:AppData\p4v\cache -ItemType directory
}

switch ($command)
{
    "install" {P4V-Install $packageName $source $Version}
    { @("update", "list") -contains $_ } {Run-NuGet $command -PackageName $packageName -Source $source -Version $Version $true}
    "uninstall" {}
    "pack" {P4V-Pack}
    default {Write-Host "Please, specify the command: install, update, list, uninstall, pack"}
}