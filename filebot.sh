#!/bin/bash
#

# Remove openjdk if installed
  apt-get purge openjdk*

# Add repositor and install java installer
  add-apt-repository ppa:webupd8team/java
  apt-get update
  apt-get install oracle-java8-installer gdebi

# Download filebot and install
  wget sourceforge.net/projects/filebot/files/filebot/FileBot_4.5/filebot_4.5_amd64.deb
  gdebi filebot_4.5_amd64.deb
  
# Change ownership of the filebot config file to the filebotuser (normal user)
  chown -R $USER:$USER ~/.filebot/
