# How to Install SkyWay IoT SDK

SkyWay IoT SDK is kind of framework rather than saying libraries. This framework consists of several building blocks as shown below.

- [Janus Gateway + SkyWay Plugin](https://github.com/nttcom/janus-skywayiot-plugin)
  - WebRTC gateway feature within the framework. For example, Janus Gateway establish WebRTC P2P connection between device and client, then relays pure RTP base media streaming data ( provided by streaming process explained below ) into WebRTC media streaming protocol (ICE + SRTP). By using SkyWay Plugin, developer can control Janus Gateway feature from client api outside of Janus Signaling Protocol. Also, it gives a way to connect 3rd party app and client app leveraging DataChannel relayed by Janus Gateway.
- [SkyWay Signaling Gateway (SSG)](https://github.com/nttcom/skyway-signaling-gateway)
  - Signaling Protocol gateway between Janus REST API and SkyWay Signaling Server. Since it transform SkyWay's signaling protocol such as offer, answer and ice candidate into Janus REST API inside private network, you can easily develop global accessible WebRTC-IoT app. Because of this building block, you can get not only global accesibility but also a way for developping to control Janus Gateway by (new SkyWay API)[http://nttcom.github.io/skyway/en/alpha-release.html]. Also, it relays DataChannel data between Janus Gateway and 3rd party app.
- Streaming Process
  - Streaming Process is used for generating stream data. It generates rtp stream that will be received by Janus Gateway. This rtp data will be relayed to client app by WebRTC P2P protocol. Typically, gstreamer is used for this purpose. But in case of generating stream from file, this process is not needed. Just configuring file path to Janus Gateway is enought for it.
- Device side 3rd party app
  - Arbitrary application which will communicate with client app via DataChannel. This app will be running on IoT device and communicate with SSG via TCP socket. In most cases, making use of [SiRu Device](https://github.com/nttcom/skyway-siru-device) module would be easy to implement 3rd party app. For example, monitoring metrics such as temperature, humidity, light quantity would be a typical use-case.
- Client app
  - Arbitrary application which would be used on client side. For instance, monitoring camera streaming, realtime metrics data and operating IoT device would be a typical use-case. In most cases, makin use of [SiRu Client](https://github.com/nttcom/skyway-siru-client) module would be easy to implement your client side application.

So you need to install above building blocks on linux based IoT devices, such as raspberry PI.

## Image install

Most easy way to setup SkyWay IoT SDK will be using [this raspberry PI image](@@@). The instruction to install image is almost same as explained in [raspberry PI page](https://www.raspberrypi.org/documentation/installation/installing-images/). So, please check it for more detail.

## Manual install

We will explain how to install SkyWay IoT SDK framework manually on Debian based environment. (We assume that latest version of node v6 is already installed)

### Janus Gateway + SkyWay Plugin

* Install dependency libraries

```bash
$ sudo aptitude install libmicrohttpd-dev libjansson-dev libnice-dev \
        libssl-dev libsrtp-dev libsofia-sip-ua-dev libglib2.0-dev \
        libopus-dev libogg-dev libcurl4-openssl-dev pkg-config gengetopt \
        libtool automake
```

* Install libsctp

```bash
$ git clone https://github.com/sctplab/usrsctp
$ cd usrsctp
$ ./bootstrap
$ ./configure --prefix=/usr; make; sudo make install
```

* Install Janus-gateway & skywayiot-plugin

```bash
$ cd ~/janus-install
$ git clone --branch v0.2.1 https://github.com/meetecho/janus-gateway.git
$ git clone --branch https://github.com/eastandwest/janus-skywayiot-plugin.git
$ cd janus-skywayiot-plugin
$ bash addplugin.sh

$ cd ../janus-gateway
$ sh autogen.sh
$ ./configure --prefix=/opt/janus --disable-mqtt --disable-rabbitmq --disable-docs --disable-websockets
$ make
$ sudo make install
$ sudo make configs
```

* update configs

``/opt/janus/etc/janus/janus.plugin.streaming.cfg``

```
;comment out lines for [gst-rpwc], then append example streaming setting shown below
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
turn_rest_api = http://iot-turn.skyway.io/api
turn_rest_api_key = demonstrationkey
turn_rest_api_method = GET
```

Please be sure that you can use our dedicated turn server for demonstration needs. Since current SkyWay TURN feature does not have compatibility with IoT SDK, for developers demonstration convenience, we setupped shared turn server. If you want to use SkyWay IoT SDK for your own purpose, please setup and use your own TURN server. [Coturn](https://github.com/coturn/coturn) will be one option to setup your server. Please be sure that we will not guarantee our demonstration TURN server.

### SSG

* install SSG

```bash
$ git clone https://github.com/nttcom/skyway-signaling-gateway.git
$ cd signalinggateway
$ npm install
```

* update configs

``signalinggateway/conf/skyway.yaml``

```bash
## set API key and origin according to the setting you configured in https://skyway.io/ds.
apikey: SET_YOUR_OWN_APIKEY
origin: SET_YOUR_OWN_ORIGIN
```

For obtaining apikey and setting domain of origin, please login or sign up at [Our SkyWay dashboard](https://skyway.io/ds/)

### Streaming Process (gstreamer)

* install gstreamer

```bash
$ sudo apt-get update
$ sudo apt-get install libgstreamer1.0-0 libgstreamer1.0-dev gstreamer1.0-nice gstreamer1.0-plugins-base \
      gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-doc gstreamer1.0-tools
```

### SiRu-device (utility library for building 3rd party app)

* install SiRu-device

```bash
$ git clone https://github.com/nttcom/skyway-siru-device.git
$ cd SiRu-device
$ npm install
```

## Next Step

Time to test the sample app to check SkyWay IoT SDK completely installed.
see [Getting Started - How to use sample app](./how_to_use_sample_app.md)