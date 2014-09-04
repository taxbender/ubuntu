#!/bin/bash
#
# Install python, python-pip and flexget
  apt-get -y install python2.7
  apt-get -y install python-pip
  pip install flexget

# Add the transmission plugin; Allows FlexGet and Transmission to talk
  pip install  transmissionrpc
  
# Create FlexGet working area
  sudo -u debian-transmission mkdir /etc/transmission-daemon/.flexget
  
# Create empty FlexGet config file
  sudo -u debian-transmission touch /etc/transmission-daemon/.flexget/config.yml
