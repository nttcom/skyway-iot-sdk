# API reference - SkyWay IoT Pure API

In SkyWay IoT SDK framework, you can use [SkyWay api](https://webrtc.ecl.ntt.com/en/js-tutorial.html) without any change. So, you can develop your own web app with SkyWay API.

However, several things you have to be care while using pure SkyWay API.

## including skyway library

We only support release version of [SkyWay library](https://webrtc.ecl.ntt.com/en/developer.html).

```html
<script type='text/javascript' src='https://cdn.webrtc.ecl.ntt.com/skyway-latest.js'></script>
```

## media stream

before getting media streaming from device, you need to establish data channel with device, then send dedicated message.
sample code is like this.

```js
const peer = new Peer({key: MY_APIKEY})

peer.on('open', id => {
  const mypeerid = id
  const conn = peer.connect(PEERID_OF_SSG, {serialization: "none", reliable: true});
  // you can check the peerid of SSG in log message. Or, you can specify peerid of SSG. For more detail please check https://github.com/nttcom/skyway-signaling-gateway

  conn.on('open', () => {
    // send media stream request
    conn.send(`SSG:stream/start,${mypeerid}`); 
  });

  // event handler for media stream from device
  peer.on('call', stream => { ... })
})
```

When you want to stop media streaming, send `SSG:stream/stop` message.

```js
conn.send('SSG:stream/stop')
```

## keepalive

To keep WebRTC connection between client and devicee, you need to send keepalive message with data channel every 25 seconds.

```js
setInterval((ev) => {
  conn.send(`SSG:keepalive,${mypeerid}`)
}, 25000)
```
 
---
Copyright. NTT Communications All Rights Reserved.
