#!/bin/bash

# Script to install [SkyWay IoT SDK](https://github.com/nttcom/skyway-iot-sdk) onto general debian series.
# Tested environments are:
#   Ubuntu16.04
#   Raspbian jessie
#
# Run as root or insert `sudo -E` before `bash`

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
    echo "${bold}${blue}${title}${normal}"
    echo
    echo "  ${text}"
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

install_prerequired() {
print_status "Install pre-required packages"

exec_cmd 'apt-get update'
exec_cmd 'apt-get install -y git aptitude'

print_status "Finished to install pre-required packages"
}

install_nodejs() {
print_status "Install node 8.x"

curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt-get -y install nodejs build-essential

print_status "Finished to install nodejs"
}

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
exec_cmd "cd ./tmp;git clone --branch v0.4.3 https://github.com/nttcom/janus-skywayiot-plugin.git"
exec_cmd "cd ./tmp/janus-skywayiot-plugin;bash addplugin.sh"
exec_cmd "cd ./tmp/janus-gateway;sh autogen.sh;./configure --prefix=/opt/janus --disable-mqtt --disable-rabbitmq --disable-docs --disable-websockets;make;make install;make configs"

exec_cmd "rm -rf tmp"

##
## todo update configs.
##
# /opt/janus/etc/janus/janus.plugin.streaming.cfg
TARGET="/opt/janus/etc/janus/janus.plugin.streaming.cfg"

exec_cmd "sed -i.bak -e '44,74 s/^/;/g' ${TARGET}"

echo '; Sample config for SkyWay IoT SDK' | tee -a ${TARGET}
echo '; This streams H.246 as video and opus as audio codec' | tee -a ${TARGET}
echo ';' | tee -a ${TARGET}
echo '[skywayiotsdk-example]' | tee -a ${TARGET}
echo 'type = rtp' | tee -a ${TARGET}
echo 'id = 1' | tee -a ${TARGET}
echo 'description = SkyWay IoT SDK H264 example streaming' | tee -a ${TARGET}
echo 'audio = yes' | tee -a ${TARGET}
echo 'video = yes' | tee -a ${TARGET}
echo 'audioport = 5002' | tee -a ${TARGET}
echo 'audiopt = 111' | tee -a ${TARGET}
echo 'audiortpmap = opus/48000/2' | tee -a ${TARGET}
echo 'videoport = 5004' | tee -a ${TARGET}
echo 'videopt = 96' | tee -a ${TARGET}
echo 'videortpmap = H264/90000' | tee -a ${TARGET}
echo 'videofmtp = profile-level-id=42c01f\;packetization-mode=1' | tee -a ${TARGET}

# /opt/janus/etc/janus/janus.transport.http.cfg
TARGET="/opt/janus/etc/janus/janus.transport.http.cfg"

exec_cmd "sed -i.bak -e 's/^https = no/https = yes/' ${TARGET}"
exec_cmd "sed -i -e 's/^;secure_port/secure_port/g' ${TARGET}"

# /opt/janus/etc/janus/janus.cfg
TARGET="/opt/janus/etc/janus/janus.cfg"

exec_cmd "sed -i.bak -e 's/^;stun_server = stun.voip.eutelia.it/stun_server = stun.webrtc.ecl.ntt.com/' ${TARGET}"
exec_cmd "sed -i -e 's/^;stun_port/stun_port/' ${TARGET}"
exec_cmd "sed -i -e 's/^;turn_server = myturnserver.com/turn_server = 52.41.145.197/' ${TARGET}"
exec_cmd "sed -i -e 's/^;turn_port = 3478/turn_port = 443/' ${TARGET}"
exec_cmd "sed -i -e 's/^;turn_type = udp/turn_type = tcp/' ${TARGET}"
exec_cmd "sed -i -e 's/^;turn_user = myuser/turn_user = siruuser/' ${TARGET}"
exec_cmd "sed -i -e 's/^;turn_pwd = mypassword/turn_pwd = s1rUu5ev/' ${TARGET}"

print_status "Finished to install Janus"
}

install_gstreamer() {
print_status "Install gstreamer"

exec_cmd "apt-get update"
exec_cmd "apt-get install -y gstreamer1.0"

print_status "Finished to install gstreamer"
}


install_ssg() {
print_status "Install SkyWay Signaling Gateway"
exec_cmd "npm install -g skyway-signaling-gateway@0.5.6"

print_status "Finished to install SSG"
}

install_mosquitto() {
print_status "Install mosquitto"
exec_cmd "apt-get install -y mosquitto mosquitto-clients"

print_status "Finished to install mosquitto and clients"
}

install() {
print_bold "Install pre-required packages"
install_prerequired
install_nodejs

print_bold "Install Janus"
install_janus

print_bold "Install gstreamer"
install_gstreamer

print_bold "Install SkyWay Signaling Gateway"
install_ssg

print_bold "Install mosquitto"
install_mosquitto
}

print_final() {
  print_bold "Installation finished!" "run 'ssg setup'\n  (You need to get your API key from https://webrtc.ecl.ntt.com/en/login.html.)"
}

start() {
  install

  print_final
}

start
