# Getting started - how to use SkyWay IoT Room Utility (SiRu)

For building WebRTC IoT app, we recommend you to use **SkyWay IoT Room Utility (SiRu)**. With SiRu, you can

* have room base connectivity with clients and devices inside room. You don't care about each peerid.
* get Media Streaming from IoT device super easy way. This makes easy to build app for monitoring camera, for instance.
* have MQTT proxy messaging inside room on top of the data channel.

Below, we will explain about how to use SiRu.

## load module

SiRu has a JS client library for browser.

* pre-built

```html
<script src="https://nttcom.github.io/skyway-siru-client/dist/skyway-siru-client.min.js"></script>
```

You don't need including skyway library, since it is already involved in siru-client.

* with webpack

```bash
$ npm install skyway-siru-client
```

then,

```js
const SiRuClient = require('skyway-siru-client')
```

## Coding

In this tutorial, we assume that `ssg start` is executed with `ROOMNAME=testroom MQTT_URL=mqtt://localhost MQTT_TOPIC=testtopic/+` on the linux machine.

First, you need to create `siru-client` instance by indicating room name and APIKEY. This library will connect to the linux device which runs `janus` and `ssg`. When connection is established, `connect` event will be fired.

```js
// here room name is `testroom` and APIKEY is `01234567-0123-0123-0123456789ab`
// Room name must be same with ROOMNAME environment for `ssg start`.
const client = new SiRuClient('testroom', {key: '01234567-0123-0123-0123456789ab'})


client.on('connect', () => {
  // ...
})
```

## Getting Media Streaming from device

When device join the room, event ``meta`` will be fired. (meta data is configured in ``~/.ssg/profile.yaml``.)

Here, meta data has ``uuid`` property which is automatically allocated while 1st execution process of ssg. By indicating ``uuid``, you can request media streaming from device.

```js
client.on('meta', profile => {
  client.requestStreaming(profile.uuid)
    .then(stream => {
      const video = document.querySelector('video')
      video.srcObject = stream

      video.onloadedmetadata = (ev) => {
        video.play()
      }
    })
})
```

## MQTT proxy

SiRu-client supports MQTT proxy messaging inside room with full-mesh P2P technology without any global broaker server. 

* subscribe

Once subscribed to the MQTT topic, published message from the linux device will be proxied to web app. When message is received, `message` event will be fired.

```js
// subscribe topic
client.subscribe('testtopic/from_dev')

// when published message is received, ``message`` event will be fired.
client.on('message', (topic, mesg) => {
  console.log(`${topic}: ${mesg}`)
  // #=> 'timestamp: 1496358525304'
})
```

To test this feature, please execute `mosquitto_pub` command on the linux device ( by using our installer, mosquitto has been installed. )

```bash
mosquitto_pub -t testtopic/from_dev -m 'hello iot sdk'
```

* publish

To send message to MQTT broaker running inside the linux device, you can use `publish()` method.

```js
client.publish('testtopic/from_cli', 'hello from client')
```

Easy way to check this message is using `mosquitto_sub` on your linux device.

```bash
$ mosquitto_sub -t testtopic/+
"hello from client"
```

## sample code

* [HTML](https://github.com/nttcom/skyway-siru-client/blob/master/examples/index.html)
* [JS](https://github.com/nttcom/skyway-siru-client/blob/master/examples/script.js)


## Next Step

Now you trained how to code within SkyWay IoT SDK framework. With rewriting and referencing above code, you can easily deploy realtime monitoring app. SiRu libraries are super convenient to develop IoT apps with SkyWay. Sometime, you do not want to use SiRu API since it is abstracted. For this cases, you can use pure SkyWay API.

More detail about our API, please check below

* [API reference - SiRu Client](https://github.com/nttcom/skyway-siru-client/blob/master/docs/SiRuClient.md)

---
Copyright. NTT Communications All Rights Reserved.
