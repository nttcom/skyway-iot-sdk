# Getting started - how to use SkyWay IoT Room Utility (SiRu)

For building WebRTC IoT app, we recommend you to use **SkyWay IoT Room Utility (SiRu)**. With SiRu, you can

* have room base connectivity with clients and devices inside room. You don't care about each peerid.
* get Media Streaming from IoT device super easy way. This makes easy to build app for monitoring camera, for instance.
* have pub/sub messaging inside room. This is convenient to send metrics data from device to monitoring client.
* have REST api from client to device. This is convenient for operating device by requesting with some command data.

Below, we will explain you how to use SiRu.

## load module

SiRu has two libraries, one is for client app and another is for device.

### For client : SiRu-client

SiRu-client is SiRu library for client app. If you like ``<script>`` way,

```html
<script src="https://s3-us-west-1.amazonaws.com/skyway-iot-sdk/dist/SiRuClient.js"></script>
```

You don't need including skyway library, since it is already involved in siru-client.

Or, if you love to code with webpack etc. 

```bash
$ npm install skyway-siru-client
```

then,

```js
import SiRuClient from 'skyway-siru-client'
```

in your code.

### For device : SiRu-device

SiRu-device is library for node.js. So use npm to install this module.

```bash
$ npm install skyway-siru-device
```

then,

```js
const SiRuDevice = require('skyway-siru-device')
```

Please be sure that required processes (Janus Gateway, SSG and streaming process) is already running on IoT device. Please check [install manual](./how_to_install.md) for more detail.

## Joining a room.

Joining a room is super easy, just calling constructor and that's it. Here, we assume

* Name of room : ``testroom``
* APIKEY: ``01234567-0123-0123-0123456789ab``

Name of room is arbitrary string, so that you can use whatever string you want to use for your room (e.g. myprivateroom). However, you have to obtain APIKEY from our SkyWay DashBoard site. If you don't have it or want to use dedicated key for IoT app, please access https://skyway.io/ds/. In test cases, set ``localhost`` in your API Key setting will work fine in almost cases. Also, you need to care that apikey and origin setting in ``skyway-signaling-gateway/conf/skyway.yaml`` is configured properly (both client and device has to have same value pair).

```yaml
secure: true
apikey: 01234567-0123-0123-0123456789ab
origin: http://localhost
```

### for client

```js
const client = new SiRuClient('testroom', {key: '01234567-0123-0123-0123456789ab'})


client.on('connect', () => {
  // ...
})
```

### for device

```js
const device = new SiRuDevice('testroom')

device.on('connect', () => {
  // ...
})
```

## Getting Media Streaming from device

When device join the room, event ``meta`` will be fired. (meta data is configured in ``signalinggateway/conf/profile.yaml``.)

Here, meta data has ``uuid`` property which is automatically allocated while 1st execution of SSG. By indicating ``uuid``, you can request media streaming from device.

### for client

```js
client.on('meta', meta => {
  // obtain meta data from each device joined in the room
  const uuid = meta.uuid

  client.requestStreaming(uuid)

})

// when media stream arrived, `stream` event will be fired. Each device is identified by uuid
client.on('stream', (stream, uuid) => {
  const video = document.querySelector('video')
  video.srcObject = stream

  video.onloadedmetadata = (ev) => {
    video.play()
  }
})
```

### for device

Since media streaming is handled by SSG in itself. We don't need any coding in device side.

## Getting published data from device

SiRu supports pub/sub messaging inside room with full-mesh P2P technology (no relay server!!). Here, we will show you how to handle publised data from device on client. In this example, device will publish timestamp every 1 seconds with topic of ``timestamp``.

### for client

```js
client.on('connect', () => {
  // subscribe topic
  client.subscribe('timestamp')

  // when published message received, ``message`` event will be fired.
  client.on('message', (topic, mesg) => {
    console.log(`${topic}: ${mesg}`)
    // #=> 'timestamp: 1496358525304'
  })
})
```

### for device

```js
device.on('connect', () => {
  // publish timestamp data every 1 seconds.
  setInterval(ev => {
    device.publish('timestamp', Date.now())
  }, 1000)
})
```

## Use REST interface from client to device

SiRu supports REST interface similar to ``fetch()`` for client side and express way to handle incoming request at device side. 

As usual, to fetch data from server, you need to call server FQDN to indicate target server. However, in SkyWay IoT SDK model, we do not need to expose any information for device such as public FQDN. Since connection will be dynamically established on the fly basis in WebRTC protocol, we don't need to have permanent global reachability to the device. Instance of public FQDN, we use ``uuid`` for distinguishing each devices internally. We don't need any firewall setting in front of NAT box. This is so powerful!! Without any relay server and complicated firewall setting, you can access your device wherever you want!!

With this interface, client can easily get data from device and operate it. Here, in this example, we will show you how to ``GET /echo`` in this framework.

### for client

```js
client.on('meta', () => {
  ...
  const btn = document.querySelector('button')

  btn.addEventListener('click', ev => {
    client.fetch(uuid+'/echo/helloWorld')
      .then(res => res.text())
      .then(text => console.log(`echo message: ${text}`))
  })
})
```

### for device

```js
device.get('/echo/:message', (req, res) => {
  res.send(req.params.message)
}
```

We notice you that do not request large data with ``fetch()`` at this moment. We recommend you under 1K bytes of data. At this moment, SiRu-device chunked large data internally, however when number of chunk get larger, it get unstable (data loss tend to happen internally, of course we know that we need to fix it).

## Full sample code

Here, we will show you full sample code for this tutorial.

### client side code

* [sample/sample-client.html](../sample/sample-client.html)

### Device side code

* [sample/sample-device.js](../sample/sample-device.js)

## Next Step

Now you trained how to code within SkyWay IoT SDK framework. With rewriting and referencing above code, you can easily deploy realtime monitoring app. SiRu libraries are super convenient to develop IoT apps with SkyWay. Sometime, you do not want to use SiRu API since it is abstracted. For this cases, you can use pure SkyWay API.

More detail about our API, please check below

* [API reference - SiRu Client](./apiref/siru_client.md)
* [API reference - SiRu Device](./apiref/siru_device.md)
* [API reference - Pure API](./apiref/pure_api.md)

---
Copyright. NTT Communications All Rights Reserved.
