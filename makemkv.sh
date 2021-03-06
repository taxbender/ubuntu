#!/bin/bash

#Script downloads and installs MakeMKV in Ubuntu. 
#Original script provided by mechevar @ http://www.makemkv.com/forum2/viewtopic.php?f=3&t=5266

#To make script executable run this at the command prompt -- chmod a+x InstallMakeMkv.sh
#Then run ./InstallMakeMkv.sh


#!/bin/sh

sudo apt-get install checkinstall build-essential libc6-dev libssl-dev libexpat1-dev libavcodec-dev libgl1-mesa-dev libqt4-dev

cd /tmp/
wget "http://www.makemkv.com/download/"
export curr_version=$(grep -m 1 "MakeMKV v" index.html | sed -e "s/.*MakeMKV v//;s/ (.*//")

echo "Scraped the MakeMKV download page and found the latest version as" ${curr_version}

export bin_zip=makemkv-bin-${curr_version}.tar.gz
export oss_zip=makemkv-oss-${curr_version}.tar.gz
export oss_folder=makemkv-oss-${curr_version}
export bin_folder=makemkv-bin-${curr_version}

wget http://www.makemkv.com/download/$bin_zip
wget http://www.makemkv.com/download/$oss_zip

tar -xzvf $bin_zip
tar -xzvf $oss_zip

cd $oss_folder
./configure
make
sudo checkinstall make install

cd ../$bin_folder
make
sudo checkinstall make install

cd ..

echo removing downloaded files
rm index.html
rm $bin_zip
rm $oss_zip
rm -rf $oss_folder
rm -rf $bin_folder
