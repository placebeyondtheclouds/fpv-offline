## what the stack does

Creates an offline environment with apps needed for setting up an FPV quad.

- clones Betaflight firmware repo and compiles the firmware for the target set in `.env`
- downloads Bluejay firmware HEXes for the target and PWM set in `.env`
- clones the reps of ELRS web flasher (and downloads all the artifacts), ESC Configurator, Betaflight Configurator (latest master branch and any other branch set in the .env), the Blackbox viewer, AM32 Configurator, ELRS configurator electron app in guacamole (for compiling modified ELRS firmware), builds them at container image build stage. Everything is downloaded and baked into the images so the consequent startups are fast.
- elrs configurator app to compile elrs firmware: `Electron → Xvfb desktop → internal VNC → guacd → Guacamole web UI`
- starts the `homepage` container for a convenient [starting page](http://localhost:81)
  <br><img src="./image.png" alt="screenshot" width="50%">

## video on Youtube about the motivation behind this repo

[![Flashing Betaflight offline](https://img.youtube.com/vi/1Zfap0P8PoI/0.jpg)](https://www.youtube.com/watch?v=1Zfap0P8PoI "Flashing Betaflight offline")

## the host requirements to run this stack

Ubuntu VM with docker. or baremetal windows with docker. here are the [instructions how to install docker on debian](https://github.com/placebeyondtheclouds/gpu-home-server?tab=readme-ov-file#continue-setting-up-the-debian-lxc-with-gpu-enabled-docker). for ubuntu just replace `debian` with `ubuntu` in one command

## env vars setup

check for new versions at:

```
https://github.com/betaflight/betaflight
https://github.com/betaflight/blackbox-log-viewer
https://github.com/betaflight/betaflight-configurator
https://github.com/bird-sanctuary/bluejay
https://github.com/stylesuxx/esc-configurator
https://github.com/am32-firmware/am32-configurator
https://github.com/KoffeinFlummi/bucksaw
```

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

## first run (do it once)

`git clone https://github.com/placebeyondtheclouds/fpv-offline.git && cd fpv-offline && chmod 777 fw`

## ELRS fork with packet encryption

[Such an imressive piece of work!](https://github.com/PotatoSpudowski/MurmurLRS.git)

`mkdir -p elrs-firmware-src && cd elrs-firmware-src && git clone --branch master  --depth 1 https://github.com/PotatoSpudowski/MurmurLRS.git`

**the firmware must be compiled with the binding phrase set, otherwise it will not turn on the encryption**. binding phrase set after flashing is not enabling the encryption. pretty easy to overlook and is very dangerous from the OPSEC perspective. add random UID to `src/user_defines.txt` just in case and verify that it is there after flashing (which means the encryption was enabled at build)

```
-DMURMUR_ENCRYPT
-DMY_UID=11,22,33,44,55,66
```

or

```
-DMY_BINDING_PHRASE="thephrase"
```

It is better to use the regular ELRS configurator software and flash through serial and Betaflight passthrough. set only binding phrase and regulatory domain, do not change other options.

if flashing with this repo tools, host directory `./elrs-firmware-src` is mounted in ELRS configurator container as `/firmware` and can be used to access ELRS source code from inside the container. the binaries compiled inside the container are in src/.pio/build. I had to flash the official elrs4 before flashing murmurlrs over wifi, otherwise there were problems with ESP8285 receiver.

## (optional) disable calling home

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

```shell
docker compose up
```

navigate to **http://localhost:81** in Chrome browser

the firmware files are in `./fw` and are served as an open directory (**be aware**) at http://localhost:86

Betaflight Configurator is available in two builds:

- tagged version from `.env`: http://localhost:82
- `master` branch build: http://localhost:88

AM32 Configurator `master` branch build is available at http://localhost:89

Bucksaw is available at http://localhost:90

## update Betaflight or Bluejay firmware targets and options

just edit `.env` and restart the stack. set BETAFLIGHT_BRANCH to `master` (and ignore the version) to build the latest version of the firmware

## update the configurators and the Blackbox viewer versions

`docker compose down -v` to delete all volumes and `docker compose up --build --force-recreate --no-cache`, or `docker compose build --no-cache bucksaw` etc

## cleanup

```shell
docker compose up --remove-orphans
docker builder prune --force
docker system prune --force
```

## remote access

to access the services from another machine use ssh port forwarding:

`ssh -N -L 81:localhost:81 -L 82:localhost:82 -L 83:localhost:83 -L 84:localhost:84 -L 85:localhost:85 -L 86:localhost:86 -L 88:localhost:88 -L 89:localhost:89 192.168.100.175` where 192.168.100.175 is the machine where this stack is running

## todo

- [x] make elrs configurator work

## ref

- https://github.com/nvm-sh/nvm
- https://www.betaflight.com/docs/development
