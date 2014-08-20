#!/bin/bash
#
# Script automate a fresh install of applications I use on my headless Ubuntu server. 
#   I use putty to connect to my server and only add ssh-server during the initial 
#   installation process. The scipt is then copied to the default user's home directory.
#   
# This script should be run as the root, e.g. sudo $user
# Version 0.2 (Still testing)
#

# Script Variables (Default included)
  
  # Debug option
  debug_me="y"

  # Install options
  net_bond="n"                         # Bond selected interfaces
  nfs_mounts="n"                       # Create / Mount nfs shares
  email="n"                            # Install / config sSMTP mail
  sensors="n"                          # Install / config temp & drive sensors
#  deluge="n"                          # Install / config deluged and deluge-web; includes deluge user/group config
#  transmission="n"                    # Install / config Transmission; includes transmission user/group config
#  flexget="n"                         # Install / config FlexGet;
#  owncloud="n"                        # Install / config OwnCloud
#  vnc="n"                             # Install / config VNC desktop
  
  # Bonded interface variables
  Interfaces=( "eth0" "eth1" )	      # Bond interfaces / interfaces should be separated with a space
  BondName="bond0"                    # Bond interface name
  BondIP="192.168.10.2"       	      # Bond interface IP
  BondGateway="192.168.10.1"          # Bond interface gateway
  BondNetmask="255.255.255.0"         # Bond interface netmask
  BondMode="balance-rr"               # Bond mode; balance-rr provides load balancing and fault tolerance

  # NFS Mounts
  mount_ip="192.168.10.105"
  mount_path="/mnt/user"
  mounts=( "Ghost_Backup" "Media" )
  mount_opts="soft,intr,rsize=8192,wsize=8192"

  #SMTP mail variables
  email_address="email@gmail.com"
  email_password="password"


########## Install / config scripts ###  	

########## Update Repositories / Upgrade System #
apt-get -y --force-yes update
apt-get -y --force-yes upgrade  


########## Network Bonding ######################
if [ $net_bond = "y" ]
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
    cat > /etc/network/interface << EOF
auto $BondName
iface $BondName inet static
  address $BondIP
  gateway $BondGateway
  netmask $BondNetmask
  bond-mode $BondMode
  slave
  bond-miimon 100
  bond-updelay 200
  bond-downdelay 200
EOF
    
    # Add the slave interfaces to line 7 of the interface file
    for i in "${Interfaces[@]}"
      do
        $ awk '{print $7"$i "}' /etc/network/interface
      done
	
    # Bring bonded interface up
    sudo ifup $BondName
    echo "Bonded network interface created."
fi


########## NFS Client / Mounts ##################
if [ nfs_mounts = "y" ]
  then
  
    # Install nfs client app
    apt-get -y install nfs-common

    # Create mount points with the same name as NFS folders. 
    for i in "${mounts[@]}"
      do
        # Create mount point
        mkdir /home/$SUDO_USER/$i

        # Change ownership to sudo_user (normal user)
        chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/$i

        # Mount NFS folders
        mount -o $mount_opts $mount_ip:$mount_path/$i /home/$SUDO_USER/$i

        # Add mounts to fstab
        # Need to echo comment line and new line
        echo $mount_ip:$mount_path/$i /home/$SUDO_USER/$i $mount_opts >> /etc/fstab
      done
fi


########## SMTP Mail ############################
if [ $email = "y" ] 
  then
    # Install ssmtp
    sudo apt-get install ssmtp
    
    # Backup original config file
    mv /etc/ssmtp/ssmtp.conf /etc/ssmtp/ssmtp.conf.original
    
    # Create new config file with email settings for gmail
    cat > /etc/ssmtp/ssmtp.conf << EOF
root=$email_address
mailhub=smtp.gmail.com:587
AuthUser=$email_address
AuthPass=$email_password
UseTLS=YES
UseSTARTTLS=YES
rewriteDomain=gmail.com
hostname=$email_address
FromLineOverride=None
AuthMethod=LOGIN
EOF

    # sSMTP email password is stored in plain text. Change ownership
    #   and access permissions to the conf file to protect is a bit.
    chown root:mail /etc/ssmtp/ssmtp.conf
    chmod 640 /etc/ssmtp/ssmtp.conf

    # Add user to mail group & reload group assignments
    adduser $SUOD_USER mail
    
    # Create a file for the test email
    echo "This is a test email" >> /home/$SUDO_USER/testmsg.txt
    
    # Change ownership to sudo user / group. The second $SUDO_USER is hacky
    #   but works. Assumes sudo_user's primary group is the same as his name
    chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/testmsg.txt
    
    # User groups are updated on login. Script runs and then forces a 
    #  reboot. Once logged in, user should send a test email to ensure
    #  config work. Syntax for test email is:
    #  ssmtp [email@gmail.com] < testmsg.txt
fi

########## Sensors ##############################

if [ $sensors = "y"       ]
  then
    apt-get install lmsensors
    echo "Run sensors-detect as root then reboot for changes to take effect"

    # Need to figure out how to automate sensors-detect
fi

############################################################################################





########## Flexget #########################################
if [ $flexget = "y" ]
  then
    # Install python, python-pip and flexget
    apt-get -y install python2.7
    apt-get -y install python-pip
    pip install flexget
    
    # Create flexget working area
    # Add to user Crontab
fi




# not tested

# VNC desktop install / config

if [ $vnc = y ]
  then
    # Install components needed for VNC server. 
    sudo apt-get install \
      gnome-core \
      gnome-session-fallback \
      vnc4server
    # Configure the startp file for x server
    cat > /home/$USER/.vnc/xstartup << EOF
	#!/bin/sh
       
	# Uncomment the following two lines for normal desktop:
	unset SESSION_MANAGER
	# exec /etc/X11/xinit/xinitrc
	gnome-session --session=gnome-classic &

	[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
	[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
	xsetroot -solid grey
	vncconfig -iconic &
	# x-terminal-emulator -geometry 1280x1024+10+10 -ls -title "$VNCDESKTOP Desktop" &
	# x-window-manager &
EOF
    # Configure the startup scripts so VNC does not start at boot
    # Add alias to .bash_aliases for VNC start and stop

fi
