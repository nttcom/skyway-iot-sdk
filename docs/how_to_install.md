# How to Install SkyWay IoT SDK

SkyWay IoT SDK is kind of framework rather than saying libraries. This framework consists of several building blocks as shown below.

![iot sdk over view](https://s3-us-west-1.amazonaws.com/skyway-iot-sdk/skyway-iot-sdk-overview.png)

- [Janus Gateway + SkyWay Plugin](https://github.com/nttcom/janus-skywayiot-plugin)
  - WebRTC gateway feature within the framework. For example, Janus Gateway establish WebRTC P2P connection between device and client, then relays pure RTP base media streaming data ( provided by streaming process explained below ) into WebRTC media streaming protocol (ICE + SRTP). By using SkyWay Plugin, developer can control Janus Gateway feature from client api outside of Janus Signaling Protocol. Also, it gives a way to connect 3rd party app and client app leveraging DataChannel relayed by Janus Gateway.
- [SkyWay Signaling Gateway (SSG)](https://github.com/nttcom/skyway-signaling-gateway)
  - Signaling Protocol gateway between Janus REST API and SkyWay Signaling Server. Since it transform SkyWay's signaling protocol such as offer, answer and ice candidate into Janus REST API inside private network, you can easily develop global accessible WebRTC-IoT app. Because of this building block, you can get not only global accesibility but also a way for developping to control Janus Gateway by (release version of SkyWay API)[https://webrtc.ecl.ntt.com/en/js-tutorial.html]. Also, it relays DataChannel data between Janus Gateway and 3rd party app.
- Streaming Process
  - Streaming Process is used for generating stream data. It generates rtp stream that will be received by Janus Gateway. This rtp data will be relayed to client app by WebRTC P2P protocol. Typically, gstreamer is used for this purpose. But in case of generating stream from file, this process is not needed. Just configuring file path to Janus Gateway is enought for it.
- Device side 3rd party app
  - Arbitrary application which will communicate with client app via DataChannel. This app will be running on IoT device and communicate with SSG via TCP socket. In most cases, making use of [SiRu Device](https://github.com/nttcom/skyway-siru-device) module would be easy to implement 3rd party app. For example, monitoring metrics such as temperature, humidity, light quantity would be a typical use-case.
- Client app
  - Arbitrary application which would be used on client side. For instance, monitoring camera streaming, realtime metrics data and operating IoT device would be a typical use-case. In most cases, makin use of [SiRu Client](https://github.com/nttcom/skyway-siru-client) module would be easy to implement your client side application.

So you need to install above building blocks on linux based IoT devices, such as raspberry PI.

## Install

Run installer.sh as follows

> (note: Oct 20th, 2017)
> We recommend you to use [Raspbian jessie](https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2017-07-05/), since apt-get installed gstreamer1.0 on Raspbian stretch

* Ubuntu16.04 or Raspbian jessie

```bash
curl https://nttcom.github.io/skyway-iot-sdk/install_scripts/debian_based/installer.sh > installer.sh; sudo -E bash - installer.sh
rm installer.sh; sudo chown -R ${USER}:${USER} skyway-iot
```

* Raspbian stretch

```
curl https://nttcom.github.io/skyway-iot-sdk/install_scripts/raspbian_stretch/installer.sh > installer.sh; sudo -E bash - installer.sh
rm installer.sh; chown -R ${USER}:${USER} skyway-iot
```


## Next Step

To check SkyWay IoT SDK completely installed, see [Getting Started - How to use sample app](./how_to_use_sample_app.md)

---
Copyright. NTT Communications All Rights Reserved.
