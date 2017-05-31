# How to Install SkyWay IoT SDK

SkyWay IoT SDK is kind of framework rather than saying libraries. This framework consists of several building blocks as shown below.

- Janus Gateway + SkyWay Plugin ## todo - add repository link
  - WebRTC gateway feature within the framework. For example, Janus Gateway establish WebRTC P2P connection between device and client, then relays pure RTP base media streaming data ( provided by streaming process explained below ) into WebRTC media streaming protocol (ICE + SRTP). By using SkyWay Plugin, developer can control Janus Gateway feature from client api outside of Janus Signaling Protocol. Also, it gives a way to connect 3rd party app and client app leveraging DataChannel relayed by Janus Gateway.
- SkyWay Signaling Gateway (SSG) ## todo - add repository link
  - Signaling Protocol gateway between Janus REST API and SkyWay Signaling Server. Since it transform SkyWay's signaling protocol such as offer, answer and ice candidate into Janus REST API inside private network, you can easily develop global accessible WebRTC-IoT app. Because of this building block, you can get not only global accesibility but also a way for developping to control Janus Gateway by (new SkyWay API)[http://nttcom.github.io/skyway/en/alpha-release.html]. Also, it relays DataChannel data between Janus Gateway and 3rd party app.
- Streaming Process
  - Streaming Process is used for generating stream data. It generates rtp stream that will be received by Janus Gateway. This rtp data will be relayed to client app by WebRTC P2P protocol. Typically, gstreamer is used for this purpose. But in case of generating stream from file, this process is not needed. Just configuring file path to Janus Gateway is enought for it.
- Device side 3rd party app
  - Arbitrary application which will communicate with client app via DataChannel. This app will be running on IoT device and communicate with SSG via TCP socket. In most cases, making use of [SiRu Device](@@@) module would be easy to implement 3rd party app. For example, monitoring metrics such as temperature, humidity, light quantity would be a typical use-case.
- Client app
  - Arbitrary application which would be used on client side. For instance, monitoring camera streaming, realtime metrics data and operating IoT device would be a typical use-case.

So you need to install above building blocks on linux based IoT devices, such as raspberry PI.

## Image install

Most easy way to setup SkyWay IoT SDK will be using [this raspberry PI image](@@@). The instruction to install image is almost same as explained in [raspberry PI page](https://www.raspberrypi.org/documentation/installation/installing-images/). So, please check it for more detail.

## Manual install

Below, we will explain how to install them manually on Debian based environment.

### Janus Gateway + SkyWay Plugin

### SSG

### Streaming Process (gstreamer)

### Sample 3rd party app

### Sample client