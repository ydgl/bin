Dans les man pages

NAME 
SYNOPSIS
DESCRIPTION
GENERAL
SETUP
USAGE
EXAMPLES
OPTIONS
DIAGNOSTIC
EXIT VALUE
ENVIRONMENT VARIABLE
VERSION


Goals & Principle

Principe
Il y a un master
Il y a plusieurs slave
Le slave s'interesse à une liste "L" de répertoire sur le master
Chaque slave a son cache
Un slave peut être en local (dans le même réseau local que le master) :
 il monte par NFS/Samba les repertoire "L" du master
Un slave peut être en distant (en dehors du réseau local du master) :
 il monte par lien symbolique les répetoire "L" du cache
La liste des répertoires "L" est dans un fichier de paramétrage *.list

Usage



Scripts



TODO
- renommer distSync en syncCache



Voir le fichier de synchro pour voir la syntaxe du fichier


ALGO

// Network failure resistant 
// System crash resistant

// Session startup

1/ Si on est en local (présence du serveur master par appel ssh)
  // We are in local, first we check if we were in distant mode
 if distant_mode
   - démontage du distant
   - lancement de la synchronisation montante cache --> master 
   - suppression du lock distant
 - fin si
 - on pose un lock pour dire que l'on est en local
 - montage du local
 - synchronisation descendate master --> cache toutes les X minutes

2/ Sinon (on n'est pas en local)
 - Si lock local présent
   - démontage du local
   - suppression du local
   - synchronisation master --> cache
 - Fin si
 - on pose un lock pour dire que l'on est en distant

// Trap session exit
if session logout
  // Avoid slow down when logout, switch off
  if local_mode
    unmount local mode
  end

  if distant_mode
    unmount distant_mode (rm ln)
end
  
