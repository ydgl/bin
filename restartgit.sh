#!/bin/sh
function step {
echo ""
echo ----------------------------------------------------------------------
echo "STEP $*" 
}

cd 

step 1. STOPPING APACHE
sudo apachectl stop
sleep 5

step 2. UMOUNT REPOSITORY
sudo umount /Library/WebServer/Documents/gp/
sleep 5

step 3. CLEAN LOG FILES IN /var/log/apache2/
sudo rm -rf /var/log/apache2/*

step 4. MOUNT REPOSITORY
sudo mount nas-adg.local:/nfs/git /Library/WebServer/Documents/gp/
sleep 5

step 5. START APACHE
sudo apachectl start
sleep 5

step 6. CHECK STARTUP
tail -100 /var/log/apache2/error_log 

