const SiRuDevice = require('skyway-siru-device')

const device = new SiRuDevice('testroom')

device.on('connect', () => {
  // publish timestamp data every 1 seconds.
  setInterval(ev => {
    device.publish('timestamp', Date.now())
  }, 1000)
})

// handle GET /echo request from client
device.get('/echo/:message', (req, res) => {
  res.send(req.params.message)
})