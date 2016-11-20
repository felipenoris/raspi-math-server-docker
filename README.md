# raspi-math-server-docker
Raspbian version of The ideal multi-user Data Science server [math-server-docker](github.com/felipenoris/math-server-docker)

**WIP**

# Raspberry Pi 3 Setup

(1) Download *Raspbian Jessie Lite* image from [raspberrypi.org](https://www.raspberrypi.org/downloads/raspbian/).

(2) Follow [these instructions](https://www.raspberrypi.org/documentation/installation/installing-images/) to copy raspbian image to SD card.

(3) Log to you Raspberry Pi. The default user is **pi** with password **raspberry**. You can either connect your Raspberry to a screen and keyboard, or *ssh* to it.

(4) Follow these commands:

```
$ sudo su

# apt update

# apt -y upgrade

# echo "gpu_mem=16" >> /boot/config.txt

# echo "CONF_SWAPSIZE=1000" >> /etc/dphys-swapfile

# reboot
```

(5) After rebooting, follow these commands:

```

$ sudo su

# apt -y install git

# cd

# git clone https://github.com/felipenoris/raspi-math-server-docker.git

# cd raspi-math-server-docker/contrib

# chmod +x raspbian_bootstrap.sh

# ./raspbian_bootstrap.sh

```

# References

* [Getting Started with Docker on Raspberry Pi](http://blog.alexellis.io/getting-started-with-docker-on-raspberry-pi/)
