# Pour autoriser l'execution d'un programme powershell en local (sans certificat)
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

# Pour automatiser l'execution sous windows
# 1 - Aller dans taches (panneau de config)
# 2 - Créer une tache de base
# 3 - Dans démarrer un programme 
#     Programme : powershell.exe
#     Argument  : nom_fichier.ps1
#     Path      : Chemin du fichier ps1
# 


 #    #  ######  #####    ####    #         #####   ######      #    #  ######     
 ##  ##  #       #    #  #    #   #         #    #  #           ##   #  #          
 # ## #  #####   #    #  #        #         #    #  #####       # #  #  #####      
 #    #  #       #####   #        #         #    #  #           #  # #  #          
 #    #  #       #   #   #    #   #         #    #  #           #   ##  #          
 #    #  ######  #    #   ####    #         #####   ######      #    #  ######     


 #####     ##     ####         ####    ####   #    #  #    #     #     #####  ######  #####
 #    #   #  #   #            #    #  #    #  ##  ##  ##  ##     #       #    #       #    #
 #    #  #    #   ####        #       #    #  # ## #  # ## #     #       #    #####   #    #
 #####   ######       #       #       #    #  #    #  #    #     #       #    #       #####
 #       #    #  #    #       #    #  #    #  #    #  #    #     #       #    #       #   #
 #       #    #   ####         ####    ####   #    #  #    #     #       #    ######  #    #
# (enfin si vous avez fait des modifs locales)


  
# Set destination Dir for backups
$backupDestDir = "D:\JAHIA_BACKUP"

function exportdusite
{
    $siteToExport = $args[0];

    echo "exporting $siteToExport"
    
    $currDate = date -Format yyyyMMdd.hhmmss 
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "root","socle2015")))
    $exportZipFile = "export-$siteToExport-"
    $hostname = "cmsint1.pprod-apec.fr:8080"
    $targetSite = "http://$hostname/cms/export/default/monexport.zip?exportformat=site&live=false&sitebox"

    Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -OutFile $exportZipFile$currDate.zip $targetSite=$siteToExport

    echo "done $exportZipFile$currDate.zip"
}

exportdusite cadres
exportdusite jd
exportdusite recruteurs
exportdusite www
exportdusite presse
exportdusite edito

move -force -path *.zip -destination $backupDestDir







