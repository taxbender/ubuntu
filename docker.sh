# Docker install script
#
# Copied from https://get.docker.io/ubuntu/

# Check that HTTPS transport is available to APT
if [ ! -e /usr/lib/apt/methods/https ]; then
	apt-get update
	apt-get install -y apt-transport-https
fi

# Import the repository key
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

# Add the repository to your APT sources
echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list

# Install docker
apt-get update
apt-get install -y lxc-docker

#
# Alternatively, use the curl-able script provided at https://get.docker.io
#
