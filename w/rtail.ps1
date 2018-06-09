# rtail wsm1int3
# 1 - demande le credential si y a pas 
# 2 - lancer le tail dans la session ouverte
# 3 - stocke le crédential pour na pas le redemander
# 5 - en fonction du nom de la machine identifie un fichier particulier à tailer
# 4 - si pas de connexion indique les opération à faire pour pouvoir se connecter
# 4 - si pas de tail sur la machine distante indique la procédure pour le faire

param(
    [string]$REMOTE_HOST
)




Enter-PSSession -ComputerName "$REMOTE_HOST.pprod-apec.fr" -Credential "PPROD-APEC.FR\servicesint"




Get-FileTail -Wait C:\Tomcat\Tomcat8\logs\rest-server.log
#Get-FileTail -Wait C:\Tomcat\Tomcat8\logs\jahia.log