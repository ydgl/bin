
@echo off

echo JAHIA_HOME must be set
echo JAHIA_HOME=%JAHIA_HOME%

echo APEC_WEB_SI_SRC must be set
echo APEC_WEB_SI_SRC=%APEC_WEB_SI_SRC%

echo version du si à déployer -1.0-SNAPSHOT

rem pause
echo BACKUP DU SITE EXISTANT
echo _________________________________________________________________________  



echo Backup du site
echo aller dans l'onglet admin, sélectionner tous les site, faire export du site en edition

rem echo wget localhost:8080/cms/export/default/cadres.zip?exportformat=site&live=false&sitebox=cadres
rem wget localhost:8080/cms/export/default/cadres.zip?exportformat=site&live=false&sitebox=cadres


rem pause 
echo SUPPRESSIONS DU SITE EXISTANT SI BESOIN
echo _________________________________________________________________________  

echo suppression du site

echo clean du JAHIA
echo Vérifier dans Tools que rien de reste et dans le live et dans le défault (pour les sites) 
echo attention si vous devez supprimer des modules il faut le faire a la main et dans l'ordre des dépendances
rem # http://technet.microsoft.com/en-us/library/hh849971.aspx
rem # http://localhost:8080/tools/jcrBrowser.jsp?workspace=default&path=%2Fsites%2Fedito%2Fcontents%2FEmploi%2FMa-carriere%2FA-la-une%2FConseils&uuid=&value=&action=&target=#delete



rem pause
echo INSTALLATION DES MODULES
echo _________________________________________________________________________  

call %JAHIA_HOME%\stopDigitalFactory.bat
rem pause

@echo on


REM 2- Install des JAR dans l'ordre des dépendances
REM : Les Deux composant bootstrap sont déjà installés

copy TO_INSTALL\apec-template-bootstrap-responsive-1.0-SNAPSHOT.jar %JAHIA_HOME%\digital-factory-data\modules
copy TO_INSTALL\apec-taglib-1.0-SNAPSHOT.jar %JAHIA_HOME%\digital-factory-data\modules
copy TO_INSTALL\apec-rest-client-1.0-SNAPSHOT.jar %JAHIA_HOME%\digital-factory-data\modules
copy TO_INSTALL\apec-formulaires-1.0-SNAPSHOT.jar %JAHIA_HOME%\digital-factory-data\modules
copy TO_INSTALL\apec-identification-1.0-SNAPSHOT.jar %JAHIA_HOME%\digital-factory-data\modules
copy TO_INSTALL\apec-fiche-service-1.0-SNAPSHOT.jar %JAHIA_HOME%\digital-factory-data\modules
copy TO_INSTALL\apec-editorial-1.0-SNAPSHOT.jar %JAHIA_HOME%\digital-factory-data\modules
copy TO_INSTALL\apec-editorial-search-1.0-SNAPSHOT.jar %JAHIA_HOME%\digital-factory-data\modules
copy TO_INSTALL\apec-box-widgets-1.0-SNAPSHOT.jar %JAHIA_HOME%\digital-factory-data\modules
copy TO_INSTALL\apec-search-1.0-SNAPSHOT.jar %JAHIA_HOME%\digital-factory-data\modules
copy TO_INSTALL\apec-recruteurs-offres-1.0-SNAPSHOT.jar %JAHIA_HOME%\digital-factory-data\modules

@echo off

rem pause
echo IMPORTATION DES FRAGMENTS ET DES SITES
echo _________________________________________________________________________  



call %JAHIA_HOME%\startDigitalFactory.bat


echo import edito.zip
echo import cadres.zip
echo changer le nom du serveur comme suit : cadres $MONSITECADRE

echo http://cadresint1.pprod-apec.fr:8080/files/live/mounts/var/apec_site/storage/images/media/auto-promos/auto-promos-cadres/grands-carrousels-565-220/2014-vpm-envie-de-bouger-orange-565-220/1287025-6-fre-FR/2014-VPM-envie-de-bouger-orange-565-220.gif


