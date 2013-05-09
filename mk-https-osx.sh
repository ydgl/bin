#!/bin/sh
function step {
echo ""
echo ----------------------------------------------------------------------
read -p "STEP $* (enter to continue)" a
}

# C'est l'endroit ou l'on va stocker les certificats que l'on a cr√√s
CERTPATH=~/certs

# ____________________________________________________________________________
step 0.INIT (Attention on efface $CERTPATH)
echo pris de http://hints.macworld.com/article.php?story=20041129143420344
echo voir aussi http://apple.stackexchange.com/questions/25434/configuring-ssl-with-apache-under-lion
echo voir aussi http://datacenteroverlords.com/2012/03/01/creating-your-own-ssl-certificate-authority/
rm -r $CERTPATH
mkdir -p $CERTPATH
cd $CERTPATH
echo two passwords needed one for CA, one for apache private Key

# ____________________________________________________________________________
step 1.CREATE CERTIFICATE AUTHORITY
echo Don''t setup anything in the "challenge password" request
echo Add this certificate to in your browser
/System/Library/OpenSSL/misc/CA.pl -newca

# ____________________________________________________________________________
step 2.GENERATE A PRIVATE KEY FOR THE WEBSERVER
openssl genrsa -des3 -out webserver.key 1024
echo we generate a non-password protected copy of the key for Apache so that it can start up without errors. 
openssl rsa -in webserver.key -out webserver.nopass.key

# ____________________________________________________________________________
step 3. GENERATE A CERTIFICATE REQUEST
echo The certificate last 10 years
echo !!!!!!! REQUIRED Common name = url
openssl req -config /System/Library/OpenSSL/openssl.cnf \
-new -key webserver.key -out newreq.pem -days 3650

# ____________________________________________________________________________
step 4. SIGNING THE CERTIFICATE REQUEST
/System/Library/OpenSSL/misc/CA.pl -signreq

echo store information generated in subdirectory
read -p "enter directory name" subdir
mkdir $subdir
cp webserver.key webserver.nopass.key newreq.pem newcert.pem ./$subdir

# ____________________________________________________________________________
step 5. BASIC SSL CONFIGURATION FILE

echo place webserver.nopass.key as server.key in /etc/apache2
echo place webserver.pem as server.crt in /etc/apache2
echo place demoCA/cacert.pem as ca.crt in /etc/apache2
echo configure httpd.conf to enable ssl and httpd-ssl.conf
echo configure httpd-ssl.conf
echo  SSLCACertificateFile for ca.crt
