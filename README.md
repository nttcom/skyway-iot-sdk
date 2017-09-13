# SkyWay IoT SDK

Project repository for [SkyWay](https://webrtc.ecl.ntt.com/en/) IoT SDK (At this moment, open beta feature).

![iot sdk over view](https://s3-us-west-1.amazonaws.com/skyway-iot-sdk/skyway-iot-sdk-overview.png)

## What's SkyWay IoT SDK?

SkyWay IoT SDK is headless WebRTC app developement tool for linux box. Work together with SkyWay and [Janus Gateway](https://github.com/meetecho/janus-gateway), we can develop

- Global reachable WebRTC-IoT app, even though IoT is downside of NAT box. ## todo - write document about this.
- Well customized flexible and extensible remote camera monitoring app. ## todo - write document about this.
- Serverless realtime monitoring and operation app for IoT devices.  ## todo - write document about this.

Coding with SkyWay IoT SDK is super easy, especially you use SiRu (SkyWay IoT Room Utility) framework. For instance, the snipet to get media streaming and metric data from IoT device is shown below.

**for client**

```javascript
// obtain APIKEY from skyway.io.
// Don't forget to config your domain and APIKEY in our Dashboard
// https://webrtc.ecl.ntt.com/en/login.html.
const client = new SiRuClient('myroom', {key: 'YOUR_API_KEY'})

client.on('connect', () => {
  client.on('device:connected', (uuid, profile) => {
    // fetch echo api
    client.fetch( uuid+'/echo/hello' )
      .then(res => res.text())
      .then(text => console.log(text)) // #=> 'hello'

    // request remote camera streaming
    client.requestStreaming(uuid)
      .then(stream => video.srcObject = stream)
    
    // subscribe each topic
    client.subscribe('topic/temperature')
  })

  client.on('message', (topic, mesg) => {
    console.log(topic, mesg)
    // #=> 'topic/temperature 22.4'
  })
})
```

**for device**

```javascript
const device = new SiRuDevice('myroom')

// set fetch response
device.get('/echo/:mesg', (req, res) => {
  const mesg = req.params.mesg

  res.send(mesg)
})

// every 10sec, we will publish dummy temprature data
setInterval(ev => {
  device.publish('topic/temperature', '22.4')
}, 10000)
```

Please note that there is no code to handle media streaming in the device side. For media streaming, some configuration and running media streaming process, such as gstreamer, are needed at IoT device side but no coding is required.

## Platforms

We tested these platforms at this moment.

* device
  - Ubuntu 16.04
  - Raspbian Jessie
* client
  - Chrome
  - Firefox

## Dive In!

Please check out

* [How to Install](./docs/how_to_install.md)
* [Getting Started - How to use sample app](./docs/how_to_use_sample_app.md)
* [Getting Started - SkyWay IoT Room Utility(SiRu)](./docs/how_to_use_siru.md)
* [API reference - SiRu client](https://github.com/nttcom/skyway-siru-client/blob/master/docs/SiRuClient.md)
* [API reference - SiRu device](./docs/apiref/siru_device.md)
* [API reference - SkyWay IoT pure API](./docs/apiref/pure_api.md)

---
Copyright. NTT Communications All Rights Reserved.
