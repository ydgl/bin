@echo off


echo CONFIGURATION DU SERVEUR JAHIA (UNE FOIS)
echo _________________________________________________________________________  




echo JAHIA_HOME must be set
echo JAHIA_HOME=%JAHIA_HOME%

echo APEC_WEB_SI_SRC must be set
echo APEC_WEB_SI_SRC=%APEC_WEB_SI_SRC%

echo MEDIA_SRC must be set
echo MEDIA_SRC=%MEDIA_SRC%=
echo in my case = D:\utils\jahia\var

echo installer JAHIA
echo positionner la licence : http://confluence.apec.fr/x/KACKDg
echo dans move  %JAHIA_HOME%\digital-factory-config\license.xml %JAHIA_HOME%\digital-factory-config\license.old
echo dans move  license.xml %JAHIA_HOME%\digital-factory-config

echo décider du nom des serveur (à mettre dans jahia) : cadre, cadres, cadresloc , ... selon le besoin : $MONSITECADRE / $MONSITEJD ...

echo configuration du JAHIA : %JAHIA_HOME%\digital-factory-config\jahia\jahia.properties
echo urlRewriteSeoRulesEnabled                              = true
echo urlRewriteRemoveCmsPrefix                              = true
echo jahia.jcr.maxNameSize = 256

echo configuration du JAHIA : %JAHIA_HOME%\tomcat\webapps\ROOT\WEB-INF\etc\config\seo-urlrewrite.xml
echo insérer fragment-rewrite.xml en derniere rule
echo 'Modif : <to last="true">/cms/render/live/$1</to> en <to>/cms/render/live/$1</to>'

echo reconfiguration de WSM dans C:\Windows\System32\drivers\etc\hosts
echo 192.168.14.66  wsm
echo 127.0.0.1 $MONTSITECADRE


echo Récupérer les images

echo start JAHIA


%MEDIA_SRC%=D:\utils\jahia\var
echo configuration du JAHIA : mount point
echo Dans Gestion de documents / Onglet réseau
echo dans la boite nom : var
echo dans la boite vfs : D:\utils\jahia\var
echo PUBLIER LE MOUNT POINT
echo PUBLIER LES NOEUDS SOUS LE MOUNT POINT

echo INSTALLER les modules bootstrap 3 core et components

echo importer le fichier de user user-setup.csv
echo aller dans les adin des site en mode editorial
echo déclarer tout ces users comme admin des 4 sites (sauf anonyme)


echo POSTE LOCAL ET SOPHOS : autoriser l'accès en 8080
echo _________________________________________________________________________  
echo console / Config pare-feu / bouton "configurer..." en regard de "emplacement principal"
echo onglet "règle globales" / ajouter... règles comme suit
echo "Ou le port local est ..." / Autoriser / indiquer port local "8080"

