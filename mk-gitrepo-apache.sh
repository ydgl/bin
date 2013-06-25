#!/bin/sh

function step {
echo ""
echo ----------------------------------------------------------------------
read -p "STEP $* (enter to continue)" a
}

GIT_DOCROOT=/Library/Webserver/Documents/gp
APACHE_SETTINGS=/etc/apache2/
TMPDIR=/tmp/`basename $0` 

# ___________________________________________________________________________
step 0.INIT
echo "Create GIT repository exposed through Apache on Mac OS X"
echo "http://www.pkgbox.de/wordpress/2011/08/setting-up-a-git-server-on-macos-x-lion/"
echo "http://www.mobilefish.com/developer/git/git.html"
read -p "Enter repository name: " project_repo

mkdir -p $TMPDIR

# ___________________________________________________________________________
step 1.CREATE GIT REPOSITORY
cd $GIT_DOCROOT
sudo mkdir $project_repo.git
cd $project_repo.git
sudo git --bare init 
sudo cp hooks/post-update.sample hooks/post-update
cd $GIT_DOCROOT
# Useless as $GIT_DOCROOT is mounted via nfs
# sudo chown -R _www:_www $project_repo.git
cd $project_repo.git
# Useless as $GIT_DOCROOT is mounted via nfs
# sudo -u _www ./hooks/post-update
sudo ./hooks/post-update
sudo git --bare update-server-info

# ___________________________________________________________________________
step 2.SETUP ACCESS RIGHT For YDG User

echo "use : sudo htpasswd -c $APACHE_SETTINGS/other/htpasswd-git <user>"
echo "to add new user"

# Declare repository to apache
sudo cp $APACHE_SETTINGS/other/gitprojects.conf $TMPDIR/gitprojects.conf.old
cp $TMPDIR/gitprojects.conf.old $TMPDIR/gitprojects.conf.new

echo "
<Directory $GIT_DOCROOT/$project_repo.git>
    # Dav on ... only one dav on and one dav lock
    Allow from all
    Order allow,deny
    <LimitExcept GET>
        Require group $project_repo-writer
    </LimitExcept>
    AuthType Basic
    AuthName \"$project_repo Git repositories\"
    AuthUserFile /etc/apache2/other/htpasswd-git
    AuthGroupFile /etc/apache2/other/htgroup-git
</Directory>
" >> $TMPDIR/gitprojects.conf.new
sudo cp $TMPDIR/gitprojects.conf.new $APACHE_SETTINGS/other/gitprojects.conf


# Define access to apache
sudo cp $APACHE_SETTINGS/other/htgroup-git $TMPDIR/htgroup-git.old
cp $TMPDIR/htgroup-git.old $TMPDIR/htgroup-git.new
echo "
$project_repo-reader: ydg
$project_repo-writer: ydg
" >> $TMPDIR/htgroup-git.new
sudo cp $TMPDIR/htgroup-git.new $APACHE_SETTINGS/other/htgroup-git


# ___________________________________________________________________________
step 3.RESTART APACHE

sudo apachectl restart

echo "try: git clone https://ydg@git-ydg/gp/$project_repo.git"
