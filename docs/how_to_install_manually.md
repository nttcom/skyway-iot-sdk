# Install SkyWay IoT SDK Manually

## Install

We will explain how to install SkyWay IoT SDK framework manually on Debian based environment. (We assume that git and node.js version>=6.x are already installed)

### Janus Gateway + SkyWay Plugin

* Install dependency libraries

```bash
sudo aptitude install libmicrohttpd-dev libjansson-dev libnice-dev \
        libssl-dev libsrtp-dev libsofia-sip-ua-dev libglib2.0-dev \
        libopus-dev libogg-dev libcurl4-openssl-dev pkg-config gengetopt \
        libtool automake
```

* Install libsctp

```bash
git clone https://github.com/sctplab/usrsctp
cd usrsctp
./bootstrap
./configure --prefix=/usr; make; sudo make install
```

* Install Janus-gateway & skywayiot-plugin

```bash
cd ..
git clone --branch v0.2.1 https://github.com/meetecho/janus-gateway.git
git clone https://github.com/nttcom/janus-skywayiot-plugin.git
cd janus-skywayiot-plugin
bash addplugin.sh

cd ../janus-gateway
sh autogen.sh
./configure --prefix=/opt/janus --disable-mqtt --disable-rabbitmq --disable-docs --disable-websockets
make
sudo make install
sudo make configs
```

* update configs

``/opt/janus/etc/janus/janus.plugin.streaming.cfg``

Comment out several lines for ``[gstreamer-sample]``, ``[file-live-sample]`` and ``[file-ondemand-sample]``. Then append example streaming setting shown below (you can check sample configs on [this gist](https://gist.github.com/KensakuKOMATSU/430abf94081cfa9f377a7461eaaf59d7))

```
[skywayiotsdk-example]
type = rtp
id = 1
description = SkyWay IoT SDK H264 example streaming
audio = yes
video = yes
audioport = 5002
audiopt = 111
audiortpmap = opus/48000/2
videoport = 5004
videopt = 96
videortpmap = H264/90000
videofmtp = profile-level-id=42e028\;packetization-mode=1
```

``/opt/janus/etc/janus/janus.transport.http.cfg``

```
https=yes
secure_port=8089
```

``/opt/janus/etc/janus/janus.cfg``

```
[nat]
stun_server = stun.webrtc.ecl.ntt.com
stun_port = 3478

turn_server = 52.41.145.197
turn_port = 443
turn_type = tcp
turn_user = siruuser
turn_pwd = s1rUu5ev
```

Please be sure that you can use our dedicated turn server for demonstration needs. Since current SkyWay TURN feature does not have compatibility with IoT SDK, for developers demonstration convenience, we setupped shared turn server. If you want to use SkyWay IoT SDK for your own purpose, please setup and use your own TURN server. [Coturn](https://github.com/coturn/coturn) will be one option to setup your server. Please be sure that we will not guarantee our demonstration TURN server.

### SSG

* install SSG

```bash
cd ..
git clone https://github.com/nttcom/skyway-signaling-gateway.git
cd skyway-signaling-gateway
npm install
```

* update configs

``skyway-signaling-gateway/conf/skyway.yaml``

```bash
## set API key and origin according to the setting you configured in our dashboard https://webrtc.ecl.ntt.com/en/login.html.
apikey: SET_YOUR_OWN_APIKEY
origin: http://localhost # You can change origin setting, if needed. Be sure that FQDN has been configured in dashboard 'available domain'
```

For obtaining apikey and setting domain of origin, please login or sign up at [Our SkyWay dashboard](https://webrtc.ecl.ntt.com/en/login.html)

### Streaming Process (gstreamer)

* install gstreamer

**raspbian stretch**

```bash
sudo apt-get update
sudo apt-get install libgstreamer1.0-0 \
      libgstreamer1.0-dev gstreamer1.0-nice gstreamer1.0-plugins-base \
      gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
      gstreamer1.0-doc gstreamer1.0-tools gstreamer1.0-omx
```

**ubuntu16.04 or raspbian jessie**

```bash
sudo apt-get update
sudo apt-get install libgstreamer1.0
```


### SiRu-device (utility library for building 3rd party app)

* install SiRu-device

```bash
git clone https://github.com/nttcom/skyway-siru-device.git
cd skyway-siru-device
npm install
```

---
Copyright. NTT Communications All Rights Reserved.
