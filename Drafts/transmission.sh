#!/bin/bash

# Transmission config file options
ifile="/etc/debian-transmission/settings.json"                                                         # Transmission settings file
blocklistURL="http://list.iblocklist.com/?list=ydxerpxkpcfqjaybcssw&fileformat=p2p&archiveformat=gz"   # Blocklist URL
watchdir="/home/$SUDO_USER/transmission/watch"                                                         # Watch directory
completedir="/home/$SUDO_USER/transmission/complete"                                                   # Complete directory
incomplete dir="/home/$SUDO_USER/transmission/incomplete"                                              # Incomplete directory
subnetwhitelist="192.168.*.*"                                                                          # Network subnet

# Add transmission repository to get latest version releases
  apt-get install -y python-software-properties software-properties-common
  add-apt-repository -y ppa:transmissionbt/ppa

# Update sources
  apt-get -y --force-yes update

# Install transmission
  apt-get -y install transmission-cli transmission-common transmission-daemon

# Add the sudo user to transmission user group
  adduser $SUDO_USER debian-transmission

# Create transmission folders and set permissions
mkdir /home/$SUDO_USER/transmission
mkdir /home/$SUDO_USER/transmission/complete
mkdir /home/$SUDO_USER/transmission/incomplete
mkdir /home/$SUDO_USER/transmission/watch
chown -R $SUDO_USER:debian-transmission /home/$SUDO_USER/transmission
chmod -R 774 /home/$SUDO_USER/transmission

# Backup original transmission settings file
mv /etc/transmission-daemon/settings.json /etc/transmission-daemon/settings.json.org

# Create new settings file and set permissions
touch /etc/transmission-daemon/settings.json
chgrp -R debian-transmission /etc/transmission-daemon/settings.json
chmod -R 770 /etc/transmission-daemon/settings.json

# Add settings to the empty setting file
echo '{'                                                                         >> $ifile
echo '  "alt-speed-down": 50,'                                                   >> $ifile
echo '  "alt-speed-enabled": false,'                                             >> $ifile
echo '  "alt-speed-time-begin": 540,'                                            >> $ifile
echo '  "alt-speed-time-day": 127,'                                              >> $ifile
echo '  "alt-speed-time-enabled": false,'                                        >> $ifile
echo '  "alt-speed-time-end": 1020,'                                             >> $ifile
echo '  "alt-speed-up": 50,'                                                     >> $ifile
echo '  "bind-address-ipv4": "0.0.0.0",'                                         >> $ifile
echo '  "bind-address-ipv6": "::",'                                              >> $ifile
echo '  "blocklist-enabled": true,'                                              >> $ifile
echo "  \"blocklist-url\": \"$blocklistURL\","                                   >> $ifile
echo '  "cache-size-mb": 4,'                                                     >> $ifile
echo '  "dht-enabled": true,'                                                    >> $ifile
echo "  \"download-dir\": \"$completedir\","                                     >> $ifile
echo '  "download-limit": 100,'                                                  >> $ifile
echo '  "download-limit-enabled": 0,'                                            >> $ifile
echo '  "download-queue-enabled": true,'                                         >> $ifile
echo '  "download-queue-size": 5,'                                               >> $ifile
echo '  "encryption": 1,'                                                        >> $ifile
echo '  "idle-seeding-limit": 30,'                                               >> $ifile
echo '  "idle-seeding-limit-enabled": false,'                                    >> $ifile
echo "  \"incomplete-dir\": \"$incompletedir\","                                 >> $ifile
echo '  "incomplete-dir-enabled": true,'                                         >> $ifile
echo '  "lpd-enabled": false,'                                                   >> $ifile
echo '  "max-peers-global": 200,'                                                >> $ifile
echo '  "message-level": 2,'                                                     >> $ifile
echo '  "peer-congestion-algorithm": "",'                                        >> $ifile
echo '  "peer-id-ttl-hours": 6,'                                                 >> $ifile
echo '  "peer-limit-global": 200,'                                               >> $ifile
echo '  "peer-limit-per-torrent": 50,'                                           >> $ifile
echo '  "peer-port": 51413,'                                                     >> $ifile
echo '  "peer-port-random-high": 65535,'                                         >> $ifile
echo '  "peer-port-random-low": 49152,'                                          >> $ifile
echo '  "peer-port-random-on-start": false,'                                     >> $ifile
echo '  "peer-socket-tos": "default",'                                           >> $ifile
echo '  "pex-enabled": true,'                                                    >> $ifile
echo '  "port-forwarding-enabled": false,'                                       >> $ifile
echo '  "preallocation": 1,'                                                     >> $ifile
echo '  "prefetch-enabled": 1,'                                                  >> $ifile
echo '  "queue-stalled-enabled": true,'                                          >> $ifile
echo '  "queue-stalled-minutes": 30,'                                            >> $ifile
echo '  "ratio-limit": 2,'                                                       >> $ifile
echo '  "ratio-limit-enabled": false,'                                           >> $ifile
echo '  "rename-partial-files": true,'                                           >> $ifile
echo '  "rpc-authentication-required": true,'                                    >> $ifile
echo '  "rpc-bind-address": "0.0.0.0",'                                          >> $ifile
echo '  "rpc-enabled": true,'                                                    >> $ifile
echo '  "rpc-password": "{6d68586f3b379319a514ec52c9bdb9efe908b21dK952lNuh",'    >> $ifile
echo '  "rpc-port": 9091,'                                                       >> $ifile
echo '  "rpc-url": "/transmission/",'                                            >> $ifile
echo '  "rpc-username": "transmission",'                                         >> $ifile
echo "  \"rpc-whitelist\": \"127.0.0.1,$subnetwhitelist\","                      >> $ifile
echo '  "rpc-whitelist-enabled": true,'                                          >> $ifile
echo '  "scrape-paused-torrents-enabled": true,'                                 >> $ifile
echo '  "script-torrent-done-enabled": false,'                                   >> $ifile
echo '  "script-torrent-done-filename": "",'                                     >> $ifile
echo '  "seed-queue-enabled": false,'                                            >> $ifile
echo '  "seed-queue-size": 10,'                                                  >> $ifile
echo '  "speed-limit-down": 100,'                                                >> $ifile
echo '  "speed-limit-down-enabled": false,'                                      >> $ifile
echo '  "speed-limit-up": 100,'                                                  >> $ifile
echo '  "speed-limit-up-enabled": false,'                                        >> $ifile
echo '  "start-added-torrents": true,'                                           >> $ifile
echo '  "trash-original-torrent-files": false,'                                  >> $ifile
echo '  "umask": 18,'                                                            >> $ifile
echo '  "upload-limit": 100,'                                                    >> $ifile
echo '  "upload-limit-enabled": 0,'                                              >> $ifile
echo '  "upload-slots-per-torrent": 14,'                                         >> $ifile
echo '  "utp-enabled": true,'                                                    >> $ifile
echo "  \"watch-dir\": \"$watchdir\","                                           >> $ifile
echo '  "watch-dir-enabled": true'                                               >> $ifile
echo '}'                                                                         >> $ifile

# Reload transmission daemon with updated config
service transmission-daemon reload
