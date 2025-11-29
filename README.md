## setup envs

rename `sample.env` to `.env`, setup variables in `.env`. use proxy, can be blank

## the host

Ubuntu with docker. here are the [instructions how to install docker on debian](https://github.com/placebeyondtheclouds/gpu-home-server?tab=readme-ov-file#continue-setting-up-the-debian-lxc-with-gpu-enabled-docker). for ubuntu just replace `debian` with `ubuntu` in one command

## start everything

```
mkdir -p fw && sudo rm -rf ./fw/* &&  chmod 777 fw
docker compose up
```

navigate to http://localhost:81

the firmware files are in `./fw`

## dev

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
