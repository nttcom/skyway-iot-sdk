# API reference - SiRu device

## SiRuDevice

Constructor of SiRuDevice. By calling this function, device will join room indicated by roomName.

```js
const device = new SiRuDevice(roomName, [options])
```

* roomName - string
  - room name which this client will join
* options - object
  - option parameter
* options.ssgaddress - string
  - IP address of SSG (default is ``localhost``)
* options.extport - number
  - TCP port number of External interface of SSG (default is 15000)
* options.dashboardport - number
  - TCP port number of dashboard interface of SSG (default is 3000)

## get

set GET interface

```js
device.get(path, callback)
```

* path - string
  - REST path
* callback - function
  - callback function for this path

## post

set POST interface

```js
device.post(path, callback)
```

* path - string
  - REST path
* callback - function
  - callback function for this path

## put

set PUT interface

```js
device.put(path, callback)
```

* path - string
  - REST path
* callback - function
  - callback function for this path

## delete

set delete interface

```js
device.delete(path, callback)
```

* path - string
  - REST path
* callback - function
  - callback function for this path

## publish

```js
device.publish(topic, data)
```

publish data to clients in the room. data is distinguished by topic.

* topic - string
  - name of topic
* data - string|object
  - arbitrary data

## subscribe

```js
device.subscribe(topic)
```

subscribe topic

* topic - string
  - name of topic

## unsubscribe

```js
device.unsubscribe(topic)
```

unsubscribe topic

* topic - string
  - name of topic

## Event

### connect

```js
device.on('connect', () => {...})
```

fired when connected to skyway signaling server and join room procedure has completed.

### meta

```js
device.on('meta', meta => { ... })
```

fired when meta data is received from each device in the room. 

* meta - object
  - we will not completely specified for the format of meta data, but ``meta.uuid`` must be specified. You can see example meta data in [profile.yaml](https://github.com/nttcom/skyway-signaling-gateway/tree/master/conf/profile.yaml)

### message

```js
device.on('message', (topic, message) => { ... })
```

When published data will be received for subscribed topic. This event will be fired

* topic - string
  - name of topic
* message - string|object
  - arbitrary data which is published

### stream

```js
device.on('stream', stream => { ... })
```

fired when media streaming is arrived from device.

* stream - object
  - media stream object. 


## Request

request object which will be passed to REST interface as 1st argument.

* uuid - string
  - uuid of request generator client
* method - string
  - method name which is one of 'GET', 'POST', 'PUT', 'DELETE'
* params - object
  - request parameter (e.g. device.get('/echo/:message') and GET /echo/hello #=> params.message = hello)
* query - object
  - query parameter
* body - string
  - request body

## Response

response object which will be passed to REST interface as 2nd argument.

### setStatus

set status code for the response

```js
res.setStatus(code)
```

* code - number
  - status code (200, 404 etc.)

### send

send response to client

```js
res.send(data)
```

* data - string|number|object
  - arbitrary data