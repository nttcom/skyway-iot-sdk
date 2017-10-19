#!/bin/bash

# Script to install [SkyWay IoT SDK](https://github.com/nttcom/skyway-iot-sdk) onto a Ubuntu or Raspbian system.
#
# Run as root or insert `sudo -E` before `bash`
#
# curl -sL https://somewhere/setup_skyway_iot | bash -


######################################################
# utility functions
######################################################
print_status() {
    echo
    echo "## $1"
    echo
}

if test -t 1; then # if terminal
    ncolors=$(which tput > /dev/null && tput colors) # supports color
    if test -n "$ncolors" && test $ncolors -ge 8; then
        termcols=$(tput cols)
        bold="$(tput bold)"
        underline="$(tput smul)"
        standout="$(tput smso)"
        normal="$(tput sgr0)"
        black="$(tput setaf 0)"
        red="$(tput setaf 1)"
        green="$(tput setaf 2)"
        yellow="$(tput setaf 3)"
        blue="$(tput setaf 4)"
        magenta="$(tput setaf 5)"
        cyan="$(tput setaf 6)"
        white="$(tput setaf 7)"
    fi
fi

print_bold() {
    title="$1"
    text="$2"

    echo
    echo "${green}================================================================================${normal}"
    echo "${green}================================================================================${normal}"
    echo -e "${bold}${blue}${title}${normal}"
    echo
    echo -en "  ${text}"
    echo
    echo "${green}================================================================================${normal}"
    echo "${green}================================================================================${normal}"
}

bail() {
    echo 'Error executing command, exiting'
    exit 1
}

exec_cmd_nobail() {
    echo "+ $1"
    bash -c "$1"
}

exec_cmd() {
    exec_cmd_nobail "$1" || bail
}

######################################################
# Install Pre-required packages
######################################################
install_prerequired() {
print_status "Install pre-required packages"

exec_cmd 'apt-get update'
exec_cmd 'apt-get install -y git aptitude'

print_status "Finished to install pre-required packages"
}


######################################################
# Install Node 8.x
######################################################
install_nodejs() {
print_status "Install node 8.x"

curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt-get -y install nodejs build-essential

print_status "Finished to install nodejs"
}


######################################################
# Install Janus Gateway and SkyWay IoT Plugin
######################################################
install_janus() {
print_status "Install required packages"
exec_cmd "aptitude install -y libmicrohttpd-dev libjansson-dev libnice-dev libssl-dev libsrtp-dev libsofia-sip-ua-dev libglib2.0-dev libopus-dev libogg-dev libcurl4-openssl-dev pkg-config gengetopt libtool automake"
exec_cmd "mkdir tmp"

print_status "Install usrsctp"
exec_cmd "cd ./tmp;git clone https://github.com/sctplab/usrsctp"
exec_cmd "cd ./tmp/usrsctp;./bootstrap;./configure --prefix=/usr; make; sudo make install"
exec_cmd "rm -rf ./tmp/usrsctp"

print_status "Install Janus-gateway & skywayiot-plugin"
exec_cmd "cd ./tmp;git clone --branch v0.2.1 https://github.com/meetecho/janus-gateway.git"
exec_cmd "cd ./tmp;git clone https://github.com/nttcom/janus-skywayiot-plugin.git"
exec_cmd "cd ./tmp/janus-skywayiot-plugin;bash addplugin.sh"
exec_cmd "cd ./tmp/janus-gateway;sh autogen.sh;./configure --prefix=/opt/janus --disable-mqtt --disable-rabbitmq --disable-docs --disable-websockets;make;make install;make configs"

exec_cmd "rm -rf tmp"

##
## todo update configs.
##
# /opt/janus/etc/janus/janus.plugin.streaming.cfg
# /opt/janus/etc/janus/janus.transport.http.cfg
# /opt/janus/etc/janus/janus.cfg

print_status "Finished to install Janus"
}

######################################################
# Install gstreamer
######################################################
install_gstreamer() {
print_status "Install gstreamer"

apt-get update
apt-get install -y gstreamer1.0

print_status "Finished to install gstreamer"
}

######################################################
# Install SkyWay Signaling Gateway (SSG)
######################################################
install_ssg() {
exec_cmd "mkdir skyway-iot"

print_status "Install SkyWay Signaling Gateway"
exec_cmd "cd ./skyway-iot;git clone https://github.com/nttcom/skyway-signaling-gateway.git;cd skyway-signaling-gateway;npm install"

##
## todo update configs.
##
# skyway-signaling-gateway/conf/skyway.yaml (apply APIKEY variable)

print_status "Finished to install SSG"
}


############################################################
# Install SkyWay IoT Room Utility for device  (SiRu-device)
############################################################
install_siru_device() {
print_status "Install SkyWay IoT Room Utility for device"
exec_cmd "cd ./skyway-iot;git clone https://github.com/nttcom/skyway-siru-device.git;cd skyway-siru-device;npm install"

print_status "Finished to install SkyWay IoT Room Utility for device"
}



######################################################
# setup script
#
# Install all required packages, accordingly
######################################################
setup() {
print_bold "Install pre-required packages"
install_prerequired
install_nodejs

print_bold "Install Janus"
install_janus

print_bold "Install gstreamer"
install_gstreamer

print_bold "Install SkyWay Signaling Gateway"
install_ssg

print_bold "Install SkyWay IoT Room Utility for device"
install_siru_device
}

######################################################
# start script
#
# Show prompt for APIKEY, then start setup script
######################################################
start() {
print_bold "Input your SkyWay APIKEY" "APIKEY can be obtained at our dashboard.\n    (https://console-webrtc-free.ecl.ntt.com/users/login).\n  Please note that you need to set 'localhost' in your Available domains setting.\n"
read -p "Your APIKEY: " APIKEY

read -p "Attempt to start installing SkyWay IoT SDK. Is it ok? [Y/n] " PR

case ${PR} in
  "" | "Y" | "y" | "yes" | "Yes" | "YES" ) setup;;
  * ) print_status "Aborted";;
esac
}

#####################################################
# execute start script!
#####################################################
start
