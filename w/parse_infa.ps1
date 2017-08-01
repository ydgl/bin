
param(
    [ValidateScript({Test-Path $_ -PathType 'Container'})]
    [string]$START_FOLDER
)

Set-StrictMode -Version Latest

# search for pattern in directory

$pattern="SIRH_REFERENTIEL_EMPLOYES"
$pattern="rest-server/rest"
$pattern=@('compteCadre', 'gestionCadre', 'consolidationInformationCadreOrchestration', 'demandeOrchestration')

# Parse dir for patterns and put hits in _parse_file.tmp_
$exclude = @('.svn')
$items = Get-ChildItem $START_FOLDER -Recurse -Exclude $exclude | ?{ $_.fullname -notmatch $exclude } 



# Generate CSV file

$outfile = "_parse_file.tmp_.svn"
$outcsvfile = "result.svn.csv"


rm $outfile
rm $outcsvfile


Write-Output "folder , proc , variable , server , endpoint" > $outfile


for ($i=0 ; $i -lt $items.length ; $i++) {
    $item = $items[$i]

    if (-Not (Test-Path $item -PathType 'Container')) {
        Write-Output "Traite : $item ( $i / $($items.length) )"
        Select-String $item -Pattern $pattern -CaseSensitive | Out-File -Width 1000 -Append $outfile
    }
}

# src = Livraison\1-Livraison_Initiale\500-CRM-SOCLE\INIT1\Fichiers de paramètres\wf_BATCH_SOCLE_CRM_DEMANDES.liv.prm:34:$$p_URL=http://wsmxxx.apec.fr:8080/rest-server/rest/...
# CSV =                                     1                                    |              2                    |  |   3   |        4                 |         5         

Write-Host "Generate CSV ..."

# Parse $outfile for replace with regexp like sed
gc $outfile | ForEach-Object {[regex]::Replace($_, '(.+)\\(.+)\:(.+)\:(.+)\=http\:\/\/(.+)8080\/(.+)',  '$1 , $2 , $4, http://$5:8080, $6')} |  Out-File $outcsvfile

# suppress blank line
gc $outcsvfile | ?{$_.trim() -ne ""} | Out-File $outcsvfile


Write-Host "Quelques tips :"
Write-Host "  - Souvent les url de configuration ne contiennent pas l'url complète car au moment de l'appel il rajoute des morceaus ex :"
Write-Host "    $$p_URL=http://wsmxxx.apec.fr:8080/rest-server/rest/compteCadre au moment de l'appel il concatène : p_URL || idCompte || '/fermerCNIL'"
Write-Host "  - Il est pratique de chercher ""application/json"" en général la chaine est toujours écrite à coté des appel au WS (cela permet de vérifier que l'on a rien raté)"
Write-Host "  - Sur la base du fichier CSV il faut se servir de la colonne 2 pour retrouver la procédure ex : wf_BATCH_SOCLE_CRM_DEMANDES.liv.prm --> wf_BATCH_SOCLE_CRM_DEMANDES.XML"
Write-Host "  - Il n'y a pas de trunk dans le SVN informatica, il semble cependant que les dossier INFA et ParamFiles soient les plus proche du trunk"



# Get-ChildItem -Path V:\Myfolder -Filter CopyForbuild.bat -Recurse -ErrorAction SilentlyContinue -Force
