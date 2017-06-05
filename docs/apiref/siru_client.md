# API reference - SiRu client

## SiRuClient

Constructor of SiRuClient. By calling this function, client will connect to SkyWay signaling server, then join room indicated by roomName.

```js
const client = new SiRuClient(roomName, options)
```

* roomName - string
  - room name which this client will join
* options - object
  - option parameter which will be passed to SkyWay pure api. At least, options.key (string) MUST be indicated. For more detail, please check [SkyWay API page](http://nttcom.github.io/skyway/en/docs/#JS)

## fetch

Send REST API request to device.

We notice you that do not request large data with ``fetch()`` at this moment. We recommend you under 1K bytes of data. At this moment, SiRu-device chunked large data internally, however when number of chunk get larger, it get unstable (data loss tend to happen internally).

```js
client.fetch(path_with_uuid, options)
  .then(res => { ... })
  .catch(err => { ... })
```

* path_with_uuid - string
  - REST path indicated by uuid (e.g. '3f6f6873-8191-44d9-a229-bb652884dd61/echo')
* options - object
  - option parameter
* options.method - string
  - request method which is one of 'GET', 'POST', 'PUT', 'DELETE'. default is 'GET'
* options.query - object
  - request query object
* options.body - string
  - request body string

## publish

```js
client.publish(topic, data)
```

publish data to clients and devices in the room. data is distinguished by topic.

* topic - string
  - name of topic
* data - string|object
  - arbitrary data

## subscribe

```js
client.subscribe(topic)
```

subscribe topic

* topic - string
  - name of topic

## unsubscribe

```js
client.unsubscribe(topic)
```

unsubscribe topic

* topic - string
  - name of topic

## requestStreaming

```js
client.requestStreaming(uuid)
```

request media streaming to device

* uuid - string
  - uuid of the device

## stopStreaming

```js
client.stopStreaming(uuid)
```

stop media streaming from device

* uuid - string
  - uuid of the device

## Event

### connect

```js
client.on('connect', () => {...})
```

fired when connected to skyway signaling server and join room procedure has completed.

### meta

```js
client.on('meta', meta => { ... })
```

fired when meta data is received from each device in the room. 

* meta - object
  - we will not completely specified for the format of meta data, but ``meta.uuid`` must be specified. You can see example meta data in [profile.yaml](https://github.com/nttcom/skyway-signaling-gateway/tree/master/conf/profile.yaml)

### message

```js
client.on('message', (topic, message) => { ... })
```

When published data will be received for subscribed topic. This event will be fired

* topic - string
  - name of topic
* message - string|object
  - arbitrary data which is published

### stream

```js
client.on('stream', stream => { ... })
```

fired when media streaming is arrived from device.

* stream - object
  - media stream object. 

## Response

response object which will be passed for Promise of fetch()

### text

generate Promise with response text

```js
client.fetch(path_with_uuid)
  .then(res => res.text())
  .then(text => ...)
```

### json

generate Promise with parsed object from response text

```js
client.fetch(path_with_uuid)
  .then(res => res.json())
  .then(obj => ...)
```

---
Copyright. NTT Communications All Rights Reserved.
