#!/bin/bash

# Bonded interface variables
  Interfaces=( "eth0" "eth1" )	      # Bond interfaces / interfaces should be separated with a space
  BondName="bond0"                    # Bond interface name
  BondIP="192.168.10.2"       	      # Bond interface IP
  BondGateway="192.168.10.1"          # Bond interface gateway
  BondNetmask="255.255.255.0"         # Bond interface netmask
  BondMode="balance-rr"               # Bond mode; balance-rr provides load balancing and fault tolerance
  ifile="/etc/network/interfaces"     # Network interfaces file

  
########## Update Repositories / Upgrade System ##
apt-get -y --force-yes update
apt-get -y --force-yes upgrade  


########## Network Bonding Config ################

# Install bonding enslave program
apt-get install -y ifenslave-2.6

# Shut-down each interface listed in Interfaces array
for i in "${Interfaces[@]}"
  do
    sudo ifdown $i
  done

# Add bonding kernal module to boot list
echo 'bonding'                        >>/etc/modules

# Load the bonding module
modprobe bonding

# Rename original interfaces file
sudo mv /etc/network/interfaces /etc/network/interfaces.original

# Create interface file for the bonded interface
touch $ifile

echo 'auto lo'                        >>$ifile
echo 'iface lo inet loopback'         >>$ifile
echo ''                               >>$ifile

for i in "${Interfaces[@]}"
  do
    echo "auto $i"                    >>$ifile
    echo "iface $i inet manual"       >>$ifile
    echo '  bond-master bond0'        >>$ifile
    echo ''                           >>$ifile
  done

echo "auto $BondName"                 >>$ifile
echo "iface $BondName inet static"    >>$ifile
echo "  address $BondIP"              >>$ifile
echo "  gateway $BondGateway"         >>$ifile
echo "  netmask $BondNetmask"         >>$ifile
echo "  dns-nameserver $BondGateway"  >>$ifile
echo "  bond-mode $BondMode"          >>$ifile
echo '  bond-slaves none'             >>$ifile
echo '  bond-miimon 100'              >>$ifile
echo '  bond-updelay 200'             >>$ifile
echo '  bond-downdelay 200'           >>$ifile

# Bring bonded interfaces up
for i in "${Interfaces[@]}"
  do
    ifup $i
  done
