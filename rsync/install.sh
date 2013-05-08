#!/bin/sh

# décrire install clé ssh

echo "Repertoire d'install"
read installdir

# To handle ~ in installdir if any. Otherwise ~ is treated as litteral.
eval installdir=$installdir
installdir=`echo $installdir | sed 's/\/$//g'`

if [ -d "$installdir" ]; then
    echo installation dans $installdir
    cp *.sh $installdir/
    cp *.src $installdir/
    cp *.list $installdir/
    chmod +x $installdir/*.sh
else
    echo ERREUR : $installdir n''existe pas
fi

echo Pour installer la connexion sans mdp ssh
echo ssh-keygen -t rsa
echo ssh root@nas-adg.local mkdir -p /shares/.ssh
echo ssh root@nas-adg.local chmod -R 700 /shares/.ssh
echo cat .ssh/id_rsa.pub "|" ssh root@nas-adg.local 'cat >> /shares/.ssh/authorized_keys'


