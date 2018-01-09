# How to Install SkyWay IoT SDK

## Setup apikey and domains

For using SkyWay IoT SDK, you need to setup SkyWay APIKEY for your app. More detail, see [how to setup apikey](./how_to_setup_apikey.md) page.

## Install by installer

Run ``installer.sh`` as follows

> (note: Oct 20th, 2017)
>
> We recommend you to use [Raspbian jessie](https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2017-07-05/), since apt-get installed gstreamer1.0 on Raspbian stretch has issues at this moment.

* Ubuntu16.04 or Raspbian jessie

```bash
curl https://nttcom.github.io/skyway-iot-sdk/install_scripts/debian_based/installer.sh > installer.sh; sudo -E bash - installer.sh
rm installer.sh; sudo chown -R ${USER}:$(id -gn $USER) skyway-iot
```

* Raspbian stretch

```bash
curl https://nttcom.github.io/skyway-iot-sdk/install_scripts/raspbian_stretch/installer.sh > installer.sh; sudo -E bash - installer.sh
rm installer.sh; chown -R ${USER}:$(id -gn $USER) skyway-iot
```

When you run ``installer.sh``, you will see the prompt as shown below. Please input your **APIKEY** there.

![installer](https://nttcom.github.io/skyway-iot-sdk/images/install.jpg)

## Install manually

When you need to setup SkyWay IoT SDK manually for some reason, see [this instruction](./how_to_install_manually.md) page.

## Next Step

To check SkyWay IoT SDK completely installed, see [Getting Started - How to use sample app](./how_to_use_sample_app.md)

---
Copyright. NTT Communications All Rights Reserved.
