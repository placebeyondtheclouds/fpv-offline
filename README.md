## setup envs

rename `sample.env` to `.env`, setup variables in `.env`. use proxy, can be blank

## the host

Ubuntu with docker. here are the [instructions how to install docker on debian](https://github.com/placebeyondtheclouds/gpu-home-server?tab=readme-ov-file#continue-setting-up-the-debian-lxc-with-gpu-enabled-docker). for ubuntu just replace `debian` with `ubuntu` in one command

## do it once

`git clone https://github.com/placebeyondtheclouds/fpv-offline.git && cd fpv-offline && chmod 766 fw`

## start everything

```
docker compose up
```

navigate to http://localhost:81

the firmware files are in `./fw`

## update Betaflight or Bluejay firmware targets and options

just edit `.env` and restart the stack

## update configurator versions

`docker volume list` and then `docker volume rm xxx` delete all volumes and `docker compose up --build --force-recreate configurator-betaflight`

## dev

docker compose up --remove-orphans

docker compose up --build --force-recreate betaflight-fw

docker compose up --build --force-recreate configurator-betaflight

docker compose up --build --force-recreate configurator-esc

docker compose up --build --force-recreate configurator-elrs

docker compose up --build --force-recreate bluejay

docker compose up homepage

docker builder prune

docker compose up --build --force-recreate copier

## remote access

on a remote machine:

ssh -N -L 81:localhost:81 -L 82:localhost:82 -L 83:localhost:83 -L 84:localhost:84 192.168.100.175

## ref

- https://github.com/nvm-sh/nvm
