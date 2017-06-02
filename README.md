# SkyWay IoT SDK

Project repository for [SkyWay](https://skyway.io) IoT SDK (Open beta feature, currently).

## What's SkyWay IoT SDK?

SkyWay IoT SDK is headless WebRTC app developement tool for linux box. Work together with SkyWay and [Janus Gateway](https://github.com/meetecho/janus-gateway), we can develop

- Global reachable WebRTC-IoT app, even though IoT is downside of NAT box. ## todo - write document about this.
- Well customized flexible and extensible remote camera monitoring app. ## todo - write document about this.
- Serverless realtime monitoring and operation app for IoT devices.  ## todo - write document about this.

Coding with SkyWay IoT SDK is super easy, especially you use SiRu (SkyWay IoT Room Utility) framework. For instance, the snipet to get media streaming and metric data from IoT device is shown below.

**for client**

```javascript
const client = new SiRuClient('myroom', {key: 'YOUR_API_KEY'})

client.on('meta', meta => {
  const uuid = meta.uuid // uuid of connected device

  // fetch echo api
  client.fetch( uuid+'/metrics/temperature' )
    .then(res => res.text())
    .then(text => console.log(text))
    // #=> e.g. 60.00

  // request media streaming from IoT device
  client.requestStreaming(profile.uuid)
})

client.on("stream", (stream, uuid) => {
  display(uuid, stream)
})
```

**for device**

```javascript
const device = new SiRuDevice('myroom')

device.get('/metrics/:target', (req, res) => {
  const target = req.params.target
  const metric = getMetric(target)

  res.send(metric)
})
```

Please note that there is no code to handle media streaming in the device side. For media streaming, some configuration and running media streaming process, such as gstreamer, are needed at IoT device side but no coding is required.

## Dive In!

Please check out

* [How to Install](./docs/how_to_install.md)
* [Getting Started - How to use sample app](./docs/how_to_use_sample_app.md)
* [Getting Started - SkyWay IoT Room Utility(SiRu)](./docs/how_to_use_siru.md)
* [API reference - SiRu client](./docs/apiref/siru_client.md)
* [API reference - SiRu device](./docs/apiref/siru_device.md)
* [API reference - SkyWay IoT pure API](./docs/apiref/pure_api.md)