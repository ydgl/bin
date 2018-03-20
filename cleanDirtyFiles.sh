#!/usr/bin/bash


declare -a arr=(
				":2eDS_Store" 
				":2eiTunes Preferences.plist" 
				".AppleDouble" "buda_vfs.img" 
				".AppleDesktop" 
				".fonts.cache-1" 
				".Trash-1000" 
				"._.DS_Store")

echo "Remove following files / folder :"
for i in "${arr[@]}"
do
   echo "    $i"
done


read -p "Press [Enter] key to start backup..."



for i in "${arr[@]}"
do
   echo ">> Process : $i ...."
   find . -name "$i" -exec echo {} \; -exec rm -rf "{}" \;
done

 
