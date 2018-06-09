# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
Get-Childitem env:

function insertafter 
{
    $filetosplit = $args[0];
    $splitstring = $args[1];
    $filetoinsert = $args[2];

    #echo "split file $filetosplit at $splitstring to insert $filetoinsert"

    $lines=Get-Content $filetosplit
        $lines |
         ForEach-Object{
             echo $_ ;
             if ("$_" -eq "$splitstring") {
                gc $filetoinsert | echo 
             }
         
         }
}


#insertafter text1.txt bonjour text2.txt


#(gc c:\temp\test.txt).replace('[MYID]','MyValue')|sc c:\temp\test.txt

echo début

$couloir="dgsss"

echo "JAHIA est installé dans $env:JAHIA_HOME"
echo "Le fichier $env:JAHIA_HOME\tomcat\webapps\ROOT\WEB-INF\etc\config\seo-urlrewrite.xml est le fichier original"

$couloir = Read-Host 'Nom du couloir (int1, dgl, rec1, ...) ?'
$domain_apec = Read-Host 'Nom du domaine sans point devant (pprod-apec.fr, apec.fr) ?' 
$license = Read-Host 'Fichier de licence ?' 


echo "installation des règles de redirections pour xxx$couloir.$domain_apec"

copy fragment-rewrite.xml fragment-rewrite_$couloir.xml


(gc fragment-rewrite_$couloir.xml).replace('COULOIR',$couloir)|sc fragment-rewrite_$couloir.xml
(gc fragment-rewrite_$couloir.xml).replace('DOMAIN_APEC',$domain_apec)|sc fragment-rewrite_$couloir.xml


$currDate = date -Format yyyymmdd.hhmmss 
$currSeoFile = "$env:JAHIA_HOME\tomcat\webapps\ROOT\WEB-INF\etc\config\seo-urlrewrite.xml"
$to_insert = fragment-rewrite_$couloir.xml

echo "remplacement du pattern dans le fichier seo-rewrite de JAHIA dans $currSeoFile"

copy $currSeoFile .\seo-urlrewrite.xml_$currDate

insertafter $currSeoFile '<!-- Outbound rules -->' $to_insert

(gc $currSeoFile).Replace('<to last="true">/cms/render/live/$1</to>','<to>/cms/render/live/$1</to>') | sc $currSeoFile



#(gc $currSeoFile).Replace('<!-- Outbound rules -->','<!-- Outbound rules -->'+$to_insert) | sc $currSeoFile

#$currSeoFile | select-string "<!-- Outbound rules -->" | %{$_.line.split()}

#%USERPROFILE%\.m2