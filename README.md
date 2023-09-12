## Overview

Day of Defeat Source (DoD:S) server in Docker

The architecture is based on nmanceau/steamcmd -> amd64.
The image contains by default Sourcemod with teammanager plugin.

## Prerequisites
None

## Quick Start
Pull the image :
```
docker pull nmanceau/dods
```

### Running
Here an example :
```
docker run -d -p 27020:27020/udp -p 27015:27015/udp -p 27015:27015 nmanceau/dods
```

## Environment variable
Every server configuration (server.cfg) should be updated from environment variable.

To do so, prefix the name of the config by 'DODS_'

For example:
* DODS_sv_lan
* DODS_hostname
* DODS_rcon_password
* ...

The image contains the last version of sourcemod.

To enable default plugin, here the environment variable:
* PLUGIN_mapchooser=true
* PLUGIN_rockthevote=true
* PLUGIN_nominations=true
* PLUGIN_randomcycle=true

## Volume
I suggest you to create volume for default folders like
* /app/dod/cfg/maps
* /app/dod/cfg/materials
* /app/dod/cfg/resource

But also for specific configuration file:
* /app/dod/cfg/mapcycle.cfg #mapcycle of the server
* /app/dod/cfg/sourcemod/mapchooser.cfg #used when PLUGIN_mapchooser is enable
* /app/dod/addons//app/dod/addons/sourcemod/configs/admins_simple.ini/configs/admins_simple.ini #admin file configuration -> [sourcemod link](https://wiki.alliedmods.net/Adding_Admins_(SourceMod))

## Docker compose example
Here an example of docker-compose which I use personnaly
```
version: "3.8"

services:
  dods:
    container_name: dods
    image: nmanceau/dods
    environment:
      - DODS_rcon_password="changeme"
      - DODS_hostname="changeme"
      - DODS_sv_lan=1
      - DODS_sv_downloadurl="changeme"
      - START_MAP=3xi_trainmap
      - PLUGIN_mapchooser=true
      - PLUGIN_rockthevote=true
      - PLUGIN_nominations=true
    volumes:
      - /docker/dods/addons/sourcemod/configs/admins_simple.ini:/app/dod/addons/sourcemod/configs/admins_simple.ini
      - /docker/dods/maps:/app/dod/maps
      - /docker/dods/materials:/app/dod/materials
      - /docker/dods/resource:/app/dod/resource
      - /docker/dods/cfg/sourcemod/mapchooser.cfg:/app/dod/cfg/sourcemod/mapchooser.cfg
      - /docker/dods/cfg/mapcycle.cfg:/app/dod/cfg/mapcycle.cfg
    network_mode: host
    restart: unless-stopped
```
