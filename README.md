## what the stack does

- clones Betaflight firmware repo and compiles the firmware for the target set in `.env`
- downloads latest at the moment (v0.21.1-RC1) version of Bluejay firmware HEXes for the target and PWM set in `.env`
- clones the repo for ESC Configurator and Betaflight Configurator, builds them at container image build stage
- starts the `homepage` container for a convenient [starting page](http://localhost:81)

## video on Youtube

[![Flashing Betaflight offline](https://img.youtube.com/vi/1Zfap0P8PoI/0.jpg)](https://www.youtube.com/watch?v=1Zfap0P8PoI "Flashing Betaflight offline")

## the host

Ubuntu VM with docker. or baremetal windows with docker. here are the [instructions how to install docker on debian](https://github.com/placebeyondtheclouds/gpu-home-server?tab=readme-ov-file#continue-setting-up-the-debian-lxc-with-gpu-enabled-docker). for ubuntu just replace `debian` with `ubuntu` in one command

## do it once

`git clone https://github.com/placebeyondtheclouds/fpv-offline.git && cd fpv-offline && chmod 777 fw`

## setup envs

rename `sample.env` to `.env`, setup targets and versions in the variables in `.env`. use proxy, can be blank.

a quote from `./src/main/target/common_pre.h` on [extra flags](https://www.betaflight.com/docs/development/API/Cloud-Build-API):

```
    CLOUD_BUILD is used to signify that the build is a user requested build and that the
    features to be enabled will be defined ALREADY.

    CORE_BUILD is used to signify that the build is a user requested build and that the
    features to be enabled will be the minimal set, and all the drivers should be present.

    If neither of the above are present then the build should simply be a baseline build
    for continuous integration, i.e. the compilation of the majority of features and drivers
    dependent on the size of the flash available.

```

## disable calling home

```
sudo tee -a /etc/hosts <<-'EOF'
127.0.0.1 img.shields.io
127.0.0.1 build.betaflight.com
127.0.0.1 analytics.betaflight.com
127.0.0.1 betaflight.com
127.0.0.1 googletagmanager.com
EOF
```

for windows, it's in `C:\Windows\System32\drivers\etc`

## start everything

```
docker compose up
```

navigate to **http://localhost:81**

the firmware files are in `./fw`

## update Betaflight or Bluejay firmware targets and options

just edit `.env` and restart the stack

## update configurator versions

`docker volume list` and then `docker volume rm xxx` delete all volumes and `docker compose up --build --force-recreate configurator-betaflight configurator-esc`

## cleanup

```
docker compose up --remove-orphans
docker builder prune
docker system prune
```

## remote access

on the local machine:

`ssh -N -L 81:localhost:81 -L 82:localhost:82 -L 83:localhost:83 -L 85:localhost:85 192.168.100.175`

## ref

- https://github.com/nvm-sh/nvm
- https://www.betaflight.com/docs/development
