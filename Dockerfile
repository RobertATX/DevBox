############################################################
# Dockerfile
# Based on Ubuntu
# This is the Dev Build
############################################################

# Set the base image to Ubuntu
FROM ubuntu:wily

# File Author / Maintainer
MAINTAINER Robert Donovan <admin@mixfin.com>

run apt-get update -y
run apt-get install -y mercurial
run apt-get install -y git
run apt-get install -y curl
#run apt-get install -y vim
#run apt-get install -y strace
#run apt-get install -y diffstat
#run apt-get install -y pkg-config
#run apt-get install -y cmake
run apt-get install -y build-essential
run apt-get install -y tcpdump
run apt-get install -y screen

# Install Python
run apt-get install -y python
run apt-get install -y python-dev
run apt-get install -y python-setuptools

# Install mySQL
run apt-get install -y libmysqlclient-dev

# Setup home environment
run useradd dev
run mkdir /home/dev && chown -R dev: /home/dev
run mkdir -p /home/dev/go /home/dev/bin /home/dev/lib /home/dev/include
env PATH /home/dev/bin:$PATH
env PKG_CONFIG_PATH /home/dev/lib/pkgconfig
env LD_LIBRARY_PATH /home/dev/lib
env GOPATH /home/dev/go:$GOPATH

# Create a shared data volume
# We need to create an empty file, otherwise the volume will
# belong to root.
# This is probably a Docker bug.
run mkdir /var/shared/
run touch /var/shared/placeholder
run chown -R dev:dev /var/shared
volume /var/shared

workdir /home/dev
env HOME /home/dev
add vimrc /home/dev/.vimrc
add vim /home/dev/.vim
add bash_profile /home/dev/.bash_profile
add gitconfig /home/dev/.gitconfig

# Link in shared parts of the home directory
run ln -s /var/shared/.ssh
run ln -s /var/shared/.bash_history
run ln -s /var/shared/.maintainercfg

run chown -R dev: /home/dev
user dev
