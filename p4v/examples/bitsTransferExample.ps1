try{
    md -Name addons
}
catch {
    Write-Debug "addons directory already exists"
}

Import-Module BitsTransfer
Start-BitsTransfer http://vvvv.org/sites/all/modules/general/pubdlcnt/pubdlcnt.php?file=http://vvvv.org/sites/default/files/uploads/killVVVV.zip addons/