#!/bin/bash
#
# This script configures a fresh install of Ubuntu Server to my liking. 
#   Assumes a base install with ssh-server installed when the
#   system is set up.
#
# Version 0.2
#

# Script Variables (Default values)
  
  # Install options
  bond = "y"       	          		# Bond interfaces?
  mail = "y"                      # Install / configure SMTP mail
  deluge = "y"                    # Install / configure deluged and deluge-web; includes deluge user/group config
  transmission = "y"              # Install / configure Transmission; includes transmission user/group config
  flexget = "y"                   # Install / configure FlexGet;
  owncloud = "y"                  # Install / configure OwnCloud
  git = "y"                       # Install / configure Git; configs for flexget/transmission live here
  
  # Bonded interface variables
  Interfaces=( "eth0" "eth1" )	  # Bond interfaces / network adapters
  BondName = "bond0"              # Bond interface name
  BondIP = 192.168.10.2       	  # Bond interface IP
  BondGateway = 192.168.10.10			# Bond interface gateway
  BondNetmask = 255.255.255.0		  # Bond interface netmask
  BondMode = "balance-rr"			    # Bond mode; balance-rr provides load balancing and fault tolerance

  #SMTP mail variables
  
  
# Update Repositories / Upgrade System
sudo apt-get -y --force-yes update
sudo apt-get -y --force-yes upgrade  


### Install / config scripts ###  
  
# Bonded interface 

if [ $bond = Y ]
  then
    # Install bonding enslave program
    sudo apt-get ifenslave
    
    # Shut-down each interface listed in Interfaces array
    for i in "${Interfaces[@]}"
      do
        sudo ifdown $i
      done
    # End of loop
	
    # Copy original interfaces file
    sudo cp /etc/network/interface /etc/network/interface.original
	
    # Create interface file for the bonded interface
    cat >	/etc/network/interface <<"EOF"
      line 1, auto $BondName
      line 2, iface $BondName inet static
      line 3,   address $BondIP
      line 4,   gateway $BondGateway
      line 5,   netmask $BondNetmask
      line 6,   bond-mode $BondMode
      line 7,   slave
      line 8,   bond-miimon 100
      line 9,   bond-updelay 200
      line 9,   bond-downdelay 200
EOF
    
    # Add the slave interfaces to line 7 of the interface file
    for i in "${Interfaces[@]}"
      do
        $ awk '{print $7"$i "}' /etc/network/interface
      done
    # End of loop
	
    # Bring bonded interface up
    sudo ifup $BondName
 
    echo "Bonded network interface created"
	else
	# Do nothing

 fi
	
  
**************************************************************************************

	
 







install mail
config mail
send test mail
install deluged
install deluge-web
set up deluge user 
set up deluge scripts


install flexget
set up basic flexget folder/groups/permission (run as deluge user)

create fstab mount points


install owncloud







sudo apt-get -y install git-core
  
# Configure git
git config --global user.name "$git_user"
git config --global user.email "$git_email"


# Create new ssh key for Git, using the provided email as a label
ssh-keygen -t rsa -C "Git_sshKey"

echo 

clear
echo "Default applications installed"
echo ""
echo ""
  
# Option to install virtual desktop
read -p "Do you want to install vnc virtual deskptop? [$default / n] " reply

reply=${reply: -$default}

if [ $reply = y|Y ]
  then
    sudo apt-get install \
      gnome-core \
      gnome-session-fallback \
      vnc4server
    
    cat > /home/$USER/.vnc/xstartup <<EOL
    line 1, #!/bin/sh
    line 2, 
    line 3, # Uncomment the following two lines for normal desktop:
    line 4, unset SESSION_MANAGER
    line 5, #exec /etc/X11/xinit/xinitrc
    line 6, gnome-session --session=gnome-classic &
    line 7, 
    line 8, [ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
    line 9, [ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
    line 10, xsetroot -solid grey
    line 11, vncconfig -iconic &
    line 12, #x-terminal-emulator -geometry 1280x1024+10+10 -ls -title "$VNCDESKTOP Desktop" &
    line 13, #x-window-manager &
    EOL
    
    
  else
    echo ""
    echo "Virtual desktop not installed."
    echo ""
fi


   cat > /home/$USER/.vnc/xstartup <<EOL
    line 1, #!/bin/sh
    line 2, 
    line 3, # Uncomment the following two lines for normal desktop:
    line 4, unset SESSION_MANAGER
    line 5, #exec /etc/X11/xinit/xinitrc
    line 6, gnome-session --session=gnome-classic &
    line 7, 
    line 8, [ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
    line 9, [ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
    line 10, xsetroot -solid grey
    line 11, vncconfig -iconic &
    line 12, #x-terminal-emulator -geometry 1280x1024+10+10 -ls -title "$VNCDESKTOP Desktop" &
    line 13, #x-window-manager &
EOL
    
    
  else
    echo ""
    echo "Virtual desktop not installed."
    echo ""
fi
