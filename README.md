# hub.docker.com/tiredofit/osticket

[![Build Status](https://img.shields.io/docker/build/tiredofit/osticket.svg)](https://hub.docker.com/r/tiredofit/osticket)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/osticket.svg)](https://hub.docker.com/r/tiredofit/osticket)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/osticket.svg)](https://hub.docker.com/r/tiredofit/osticket)
[![Docker Layers](https://images.microbadger.com/badges/image/tiredofit/osticket.svg)](https://microbadger.com/images/tiredofit/osticket)
[![Image Size](https://img.shields.io/microbadger/image-size/tiredofit/osticket.svg)](https://microbadger.com/images/tiredofit/osticket)

# Introduction

Dockerfile to build a [OSTicket] container image.

This Container uses Alpine:Edge as a base.
Additional Components are PHP7 w/ APC, OpCache. MySQL Client is also available


[Changelog](CHANGELOG.md)

# Authors

- [Dave Conroy][https://github.com/tiredofit]

# Table of Contents

- [Introduction](#introduction)
    - [Changelog](CHANGELOG.md)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
    - [Database](#database)
    - [Data Volumes](#data-volumes)
    - [Environment Variables](#environmentvariables)   
    - [Networking](#networking)
- [Maintenance](#maintenance)
    - [Shell Access](#shell-access)
   - [References](#references)

# Prerequisites

This image assumes that you are using a reverse proxy such as [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) and optionally the [Let's Encrypt Proxy Companion @ https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion) in order to serve your pages. However, it will run just fine on it's own if you map appropriate ports.

This image also needs a Seperate MariaDB Container and optional memcached container.

If using an SSL Reverse proxy the following must be added to the proxy! (vhost.d/sitename.domain.com)

````
proxy_set_header    Host    $host;
proxy_set_header    X-Real-IP   $remote_addr;
proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_pass_header   Set-Cookie;
````

# Installation

Automated builds of the image are available on [Docker Hub](https://hub.docker.com/tiredofit/osticket) and is the recommended method of installation.

```bash
docker pull hub.docker.com/tiredofit/osticket
```

# Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.

# Configuration

### Data-Volumes

The following directories are used for configuration and can be mapped for persistent storage.

| Directory | Description |
|-----------|-------------|
| `/www/osticket` | (Not needed as we want to keep base clean, move to a custom/assets approach) Root Directory |
| `/www/logs` | Nginx and php-fpm logfiles |

### Database

Create a linked MariaDB Database and the image will automatically populate the DB upon startup.

### Environment Variables

Along with the Environment Variables from the [Base image](https://hub.docker.com/r/tiredofit/alpine), and the [Nginx+PHP-FPM Engine](https://hub.docker.com/r/tiredofit/nginx-php-fpm) below is the complete list of available options that can be used to customize your installation.

| Parameter | Description |
|-----------|-------------|
| `CRON_PERIOD` | Amount of time in Minutes to Check Incoming Mail e.g. `10`|
| `DB_HOST` | Database Host e.g. `osticket-db` |
| `DB_NAME` | Database Name e.g. `osticket` |
| `DB_USER` | Database User e.g. `osticket` |
| `DB_PASS` | Database Password e.g. `password` |
| `DB_PREFIX` | Database Prefix - Default: `ost_` |
| `SMTP_HOST` | SMTP Host - Default: `localhost` |
| `SMTP_PORT` | SMTP Host Port - Default: `25` |
| `SMTP_FROM` | SMTP From Address - Default: `osticket@hostname.com` |
| `SMTP_TLS` | Should TLS be used (`0`=no `1`=yes) - Default: `1` |
| `SMTP_USER` | SMTP Authentication user - Default Blank |
| `SMTP_PASS` | SMTP Authentication password - Default Blank |

| `INSTALL_SECRET` | A Large and Random Installation String (Auto Generates on Install if empty)
| `INSTALL_EMAIL` | Installer Email (Use different email then ADMIN_EMAIL)
| `INSTALL_NAME` | Site Name

| `ADMIN_FIRSTNAME` | First name of Admin User
| `ADMIN_LASTNAME` | Last name of Admin User
| `ADMIN_EMAIL` | Admin Email address (Make sure it is different than INSTALL_EMAIL)
| `ADMIN_USER` | Admin Username
| `ADMIN_PASS` | Admin Password

### Networking

The following ports are exposed.

| Port      | Description |
|-----------|-------------|
| `80` | HTTP |

# Maintenance
#### Resetting Password
If you need to reset the OSTicket Admin use this query
````
UPDATE `ost_staff` SET `passwd` = MD5( 'password' ) WHERE `username` = 'sdadmin';
````


#### Shell Access

For debugging and maintenance purposes you may want access the containers shell. 

```bash
docker exec -it (whatever your container name is e.g. osticket) bash
```

# References

* https://osticket.org
* https://www.nginx.org
* http://www.php.org

