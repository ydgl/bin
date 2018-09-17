# list file input
gci *.msg | % {
    $oldName=$_.BaseName + ".msg"
    $newName=$_.BaseName + ".eml"
    
    Write-Output "Traite $oldName ..."

    Copy-Item -Force $oldName tmp.msg
    Mrmapi.exe -MIME -Input tmp.msg -Output tmp.eml

    Copy-Item tmp.eml $newName

    Write-Output " $newName DONE"
}

Remove-Item tmp.msg
Remove-Item tmp.eml
