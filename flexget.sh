#!/bin/bash
#

# User / Group that flexget will run under

flexuser="debian-transmission"

# Install python, python-pip and flexget
  apt-get -y install python2.7
  apt-get -y install python-pip
  pip install flexget

# Add the transmission plugin; Allows FlexGet and Transmission to talk
  pip install transmissionrpc
  
# Create FlexGet working area
  sudo -u $flexuser -g $flexuser mkdir /etc/transmission-daemon/.flexget
  
# Create empty FlexGet config file
  sudo -u $flexuser -g $flexuser touch /etc/transmission-daemon/.flexget/config.yml
