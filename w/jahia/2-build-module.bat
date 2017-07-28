
@echo off


echo CONFIGURATION DU SERVEUR JAHIA
echo _________________________________________________________________________  

echo JAHIA_HOME must be set
echo JAHIA_HOME=%JAHIA_HOME%

echo APEC_WEB_SI_SRC must be set
echo APEC_WEB_SI_SRC=%APEC_WEB_SI_SRC%

rem Check
rem  %USERPROFILE%\.m2 settings ok
rem JAVA_HOME en JDK 1.7


REM install du serveur JAHIA
REM Check libreoffice, ffmpeg, pdf2swf

rem pause
echo BUILD DES LIVRABLES 
echo _________________________________________________________________________  


cd %APEC_WEB_SI_SRC%
svn cleanup .
svn update .
call mvn clean install

pause
@echo on

cd %APEC_WEB_SI_SRC%\pic

copy %APEC_WEB_SI_SRC%\apec-template-bootstrap-responsive\target\apec-template-bootstrap-responsive-1.0.0-SNAPSHOT.jar %APEC_WEB_SI_SRC%\pic\TO_INSTALL
copy %APEC_WEB_SI_SRC%\apec-editorial\target\apec-editorial-1.0.0-SNAPSHOT.jar %APEC_WEB_SI_SRC%\pic\TO_INSTALL
copy %APEC_WEB_SI_SRC%\apec-fiche-service\target\apec-fiche-service-1.0.0-SNAPSHOT.jar %APEC_WEB_SI_SRC%\pic\TO_INSTALL
copy %APEC_WEB_SI_SRC%\apec-taglib\target\apec-taglib-1.0.0-SNAPSHOT.jar %APEC_WEB_SI_SRC%\pic\TO_INSTALL
copy %APEC_WEB_SI_SRC%\apec-rest-client\target\apec-rest-client-1.0.0-SNAPSHOT.jar %APEC_WEB_SI_SRC%\pic\TO_INSTALL
copy %APEC_WEB_SI_SRC%\apec-formulaires\target\apec-formulaires-1.0.0-SNAPSHOT.jar %APEC_WEB_SI_SRC%\pic\TO_INSTALL
copy %APEC_WEB_SI_SRC%\apec-identification\target\apec-identification-1.0.0-SNAPSHOT.jar %APEC_WEB_SI_SRC%\pic\TO_INSTALL
copy %APEC_WEB_SI_SRC%\apec-editorial-search\target\apec-editorial-search-1.0.0-SNAPSHOT.jar %APEC_WEB_SI_SRC%\pic\TO_INSTALL
copy %APEC_WEB_SI_SRC%\apec-box-widgets\target\apec-box-widgets-1.0.0-SNAPSHOT.jar %APEC_WEB_SI_SRC%\pic\TO_INSTALL
copy %APEC_WEB_SI_SRC%\apec-search\target\apec-search-1.0.0-SNAPSHOT.jar %APEC_WEB_SI_SRC%\pic\TO_INSTALL
copy %APEC_WEB_SI_SRC%\apec-recruteurs-offres\target\apec-recruteurs-offres-1.0.0-SNAPSHOT.jar %APEC_WEB_SI_SRC%\pic\TO_INSTALL
copy %APEC_WEB_SI_SRC%\apec-profil-recherche\target\apec-profil-recherche-1.0.0-SNAPSHOT.jar %APEC_WEB_SI_SRC%\pic\TO_INSTALL



pause




