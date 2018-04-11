# How to Install SkyWay IoT SDK

## Setup apikey and domains

For using SkyWay IoT SDK, you need to setup SkyWay APIKEY for your app. More detail, see [how to setup apikey](./how_to_setup_apikey.md) page.

## Install by installer

Run ``installer.sh`` as follows

* Ubuntu16.04 or Raspbian jessie

```bash
curl https://nttcom.github.io/skyway-iot-sdk/install_scripts/debian_based/installer.sh | sudo -E bash -
```

* Raspbian stretch

```bash
curl https://nttcom.github.io/skyway-iot-sdk/install_scripts/raspbian_stretch/installer.sh | sudo -E bash -
```

After installation, please run

```
ssg setup
```

Then type your **APIKEY**.

## Install manually

When you need to setup SkyWay IoT SDK manually for some reason, see [this instruction](./how_to_install_manually.md) page.

## Next Step

To check SkyWay IoT SDK completely installed, see [Getting Started - How to use sample app](./how_to_use_sample_app.md)

---
Copyright. NTT Communications All Rights Reserved.
