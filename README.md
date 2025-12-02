## what the stack does

- clones Betaflight firmware repo and compiles the firmware for the target set in `.env`
- downloads latest at the moment (v0.21.1-RC1) version of Bluejay firmware HEXes for the target and PWM set in `.env`
- clones the repo for ESC Configurator and Betaflight Configurator, builds them at container image build stage
- starts the `homepage` container for a convenient [starting page](http://localhost:81)

## video on Youtube

<iframe width="560" height="315" src="https://www.youtube.com/embed/1Zfap0P8PoI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## the host

Ubuntu VM with docker. or baremetal windows with docker. here are the [instructions how to install docker on debian](https://github.com/placebeyondtheclouds/gpu-home-server?tab=readme-ov-file#continue-setting-up-the-debian-lxc-with-gpu-enabled-docker). for ubuntu just replace `debian` with `ubuntu` in one command

## do it once

`git clone https://github.com/placebeyondtheclouds/fpv-offline.git && cd fpv-offline && chmod 777 fw`

## setup envs

rename `sample.env` to `.env`, setup variables in `.env`. use proxy, can be blank

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

docker compose up --remove-orphans

docker builder prune

docker system prune

## remote access

on the local machine:

ssh -N -L 81:localhost:81 -L 82:localhost:82 -L 83:localhost:83 192.168.100.175

## ref

- https://github.com/nvm-sh/nvm
