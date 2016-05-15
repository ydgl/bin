#!/bin/sh

find . -name ":2eDS_Store" 
find . -name ":2eDS_Store" -exec rm \"{}\" \;
find . -name ":2eiTunes Preferences.plist" 
find . -name ":2eiTunes Preferences.plist" -exec \"{}\" \;
 
