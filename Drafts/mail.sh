#!/bin/bash

#SMTP mail variables
email_address="email@gmail.com"
email_password="password"
mconfig="/etc/ssmtp/ssmtp.conf"


########## SMTP Mail ############################

# Install ssmtp
sudo apt-get install ssmtp

# Backup original config file
mv /etc/ssmtp/ssmtp.conf /etc/ssmtp/ssmtp.conf.original

# Create new config file with email settings for gmail

echo "root=$email_address"                 >> $mconfig
echo 'mailhub=smtp.gmail.com:587'          >> $mconfig
echo "AuthUser=$email_address"             >> $mconfig
echo "AuthPass=$email_password"            >> $mconfig
echo 'UseTLS=YES'                          >> $mconfig
echo 'UseSTARTTLS=YES'                     >> $mconfig
echo 'rewriteDomain=gmail.com'             >> $mconfig
echo "hostname=$email_address"             >> $mconfig
echo 'FromLineOverride=None'               >> $mconfig
echo 'AuthMethod=LOGIN'                    >> $mconfig

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
