#!/bin/bash


# Add transmission repository to get latest version releases
  apt-get install -y python-software-properties software-properties-common
  add-apt-repository -y ppa:transmissionbt/ppa

# Update sources
  apt-get -y --force-yes update

# Install transmission
  apt-get -y install transmission-cli transmission-common transmission-daemon

# Add the sudo user to transmission user group
  adduser $SUDO_USER debian-transmission

# Create transmission folders
mkdir /home/$SUDO_USER/transmission
mkdir /home/$SUDO_USER/transmission/complete
mkdir /home/$SUDO_USER/transmission/incomplete
mkdir /home/$SUDO_USER/transmission/watch

# Change ownership & permissions of transmission folders
chown -R $SUDO_USER:debian-transmission /home/$SUDO_USER/transmission
chmod -R 774 /home/$SUDO_USER/transmission

# Create user config directory
mkdir /home/$SUDO_USER/.config
mkdir /home/$SUDO_USER/.config/transmission

# Move transmission config file to user config folder
mv /etc/transmission-daemon/settings.json /home/$SUDO_USER/.config/transmission/settings.json.original

chown -R $SUDO_USER /home/$SUDO_USER/.config
chgrp -R debian-transmission /home/$SUDO_USER/.config/transmission
chmod -R 754 /home/$SUDO_USER/.config/transmission

# Copy template config file to user config folder 
cp /home/$SUDO_USER/transmission_settings.json /home/$SUDO_USER/.config/transmission

# Create symlink from user config to /etc/transmission folder
ln -s /home/$SUDO_USER/.config/transmission/settings.json /etc/transmission-daemon/settings.json
chgrp -R debian-transmission /etc/transmission-daemon/settings.json
chmod -R 770 /etc/transmission-daemon/settings.json

# Update transmission config template with path to transmission folders
file="\/etc\/transmission-daemon/settings.json"

# sed finds and replaces text strings in the file.
# -i indicates inline text replacement
# \<string\> syntax modifies file contents with exact string/case match

# Complete folder
find="path-dir-complete"
replace="\/home\/$SUDO_USER\/transmission\/complete"
sed -i "s/\<$find\>/$replace/g" $file

# Watch folder 
find="path-dir-watch"
replace="\/home\/$SUDO_USER\/transmission\/watch"
sed -i "s/\<$find\>/$replace/g" $file

# Incomplete folder
find="path-dir-incomplete"
replace="\/home\/$SUDO_USER\/transmission\/incomplete"
sed -i "s/\<$find\>/$replace/g" $file

# Reload transmission daemon with updated config
service transmission-daemon reload
