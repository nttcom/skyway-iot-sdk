# SkyWay IoT SDK

Project repository for [SkyWay](https://webrtc.ecl.ntt.com/en/) IoT SDK (At this moment, open beta feature).

![iot sdk over view](https://nttcom.github.io/skyway-iot-sdk/images/skyway-iot-sdk-overview.png)

## What's SkyWay IoT SDK?

SkyWay IoT SDK is headless WebRTC app developement kit for linux box. Working together with SkyWay and [Janus Gateway](https://github.com/meetecho/janus-gateway), we can build global accessible WebRTC gateway services even though under NAT circumstances. Since this SDK leveraging WebRTC as a gateway feature, more flexible and extensible IoT apps we can build than using browser or mobile. For instance,

- Transfer video from [ONVIF](https://www.onvif.org/) security camera.
- Add AI features, such as face detection, on top of monitoring app.
- Enable MQTT device operation from outside without global broaker server.

Coding with SkyWay IoT SDK is super easy, especially you use SiRu (SkyWay IoT Room Utility) framework. For instance, the snipet to get media streaming and MQTT data from IoT device is shown below.

```javascript
const client = new SiRuClient('myroom', {key: 'YOUR_API_KEY'});

client.on('meta', profile => {
  client.requestStreaming(profile.uuid)
    .then(stream => video.srcObject = stream);

  client.subscribe('topic/temperature');

  client.on('message', (topic, mesg) => {
    console.log(topic, mesg);
  });

  client.publish('topic/operation', 'hello');
})
```

# New features in 0.1.x

* Running 3rd party app is not needed any more.
* MQTT relay feature is supported.
* Large size data transfer ( about 60KB ) is supported.
* Stability improved.

## Platforms

Platforms shown berow are being tested at this moment.

* device
  - Ubuntu 16.04
  - Raspbian Jessie and Stretch
* client
  - Chrome
  - Firefox

## Dive In!

Please check below

* [How to Install](./docs/how_to_install.md)
* [Getting Started - How to use sample app](./docs/how_to_use_sample_app.md)
* [Getting Started - SkyWay IoT Room Utility(SiRu)](./docs/how_to_use_siru.md)
* [API reference - SiRu client](https://github.com/nttcom/skyway-siru-client/blob/master/docs/SiRuClient.md)
* [Sample code](https://github.com/nttcom/skyway-siru-client/blob/master/examples/index.html)

Temporary unsupported documents.

* [API reference - SkyWay IoT pure API](./docs/apiref/pure_api.md)
* [API reference - SiRu device](./docs/apiref/siru_device.md)

---
Copyright. NTT Communications All Rights Reserved.
