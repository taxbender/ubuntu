#!/bin/bash

# NFS Mounts
  mount_ip="192.168.10.105"
  mount_path="/mnt/user"
  mounts=( "Ghost_Backup" "Media" )
  mount_opts="soft,intr,rsize=8192,wsize=8192"

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
    echo ''                                                                 >> /etc/fstab
    echo $mount_ip:$mount_path/$i /home/$SUDO_USER/$i nfs $mount_opts 0,0   >> /etc/fstab

  done
