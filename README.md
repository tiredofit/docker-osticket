# github.com/tiredofit/docker-osticket

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-osticket?style=flat-square)](https://github.com/tiredofit/docker-osticket/releases/latest)
[![Build Status](https://img.shields.io/github/actions/workflow/status/tiredofit/docker-osticketmain.yml?branch=main&style=flat-square)](https://github.com/tiredofit/docker-osticket.git/actions)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/osticket.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/osticket/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/osticket.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/osticket/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

* * *
## About

This will build a Docker Image for [OSTicket](https://www.osticket.com) - An open source helpdesk / ticketing system.

* Automatically installs and sets up installation upon first start

## Maintainer

- [Dave Conroy](https://github.com/tiredofit)

## Table of Contents


- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Prerequisites and Assumptions](#prerequisites-and-assumptions)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)
- [References](#references)

## Prerequisites and Assumptions
*  Assumes you are using some sort of SSL terminating reverse proxy such as:
   *  [Traefik](https://github.com/tiredofit/docker-traefik)
   *  [Nginx](https://github.com/jc21/nginx-proxy-manager)
   *  [Caddy](https://github.com/caddyserver/caddy)
*  Requires access to a MySQL/MariaDB Server

## Installation

### Build from Source
Clone this repository and build the image with `docker build -t (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/osticket)

```bash
docker pull docker.io/tiredofit/osticket:(imagetag)
```

Builds of the image are also available on the [Github Container Registry](https://github.com/tiredofit/docker-osticket/pkgs/container/docker-osticket)

```
docker pull ghcr.io/tiredofit/docker-osticket:(imagetag)
```

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):

| Container OS | Tag       |
| ------------ | --------- |
| Debian       | `:latest` |

## Configuration

### Quick Start

- The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

- Set various [environment variables](#environment-variables) to understand the capabilities of this image.
- Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
- Make [networking ports](#networking) available for public access if necessary

**The first boot can take from 2 minutes - 5 minutes depending on your CPU to setup the proper schemas.**

- Login to the web server and enter in your admin email address, admin password and start configuring the system!

### Persistent Storage
The following directories are used for configuration and can be mapped for persistent storage.

| Directory       | Description                                                                                 |
| --------------- | ------------------------------------------------------------------------------------------- |
| `/www/osticket` | (Not needed as we want to keep base clean, move to a custom/assets approach) Root Directory |
| `/www/logs`     | Nginx and php-fpm logfiles                                                                  |

### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) or [Debian Linux](https://hub.docker.com/r/tiredofit/debian) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`,`nano`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                         | Description                            |
| ------------------------------------------------------------- | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-debian/)        | Customized Image based on Debian Linux |
| [Nginx](https://github.com/tiredofit/docker-nginx/)           | Nginx webserver                        |
| [PHP-FPM](https://github.com/tiredofit/docker-nginx-php-fpm/) | PHP Interpreter                        |


| Parameter         | Description                                                                 | default                 |
| ----------------- | --------------------------------------------------------------------------- | ----------------------- |
| `INSTALL_SECRET`  | A Large and Random Installation String (Auto Generates on Install if empty) |                         |
| `INSTALL_EMAIL`   | Installer Email (Use different email then ADMIN_EMAIL)                      | `helpdesk@example.com`  |
| `INSTALL_NAME`    | Site Name                                                                   | `My Helpdesk`           |
| `ADMIN_FIRSTNAME` | First name of Admin User                                                    |                         |
| `ADMIN_LASTNAME`  | Last name of Admin User                                                     |                         |
| `ADMIN_EMAIL`     | Admin Email address (Make sure it is different than INSTALL_EMAIL)          |                         |
| `ADMIN_USER`      | Admin Username *Must be more than 5 characters*                             |                         |
| `ADMIN_PASS`      | Admin Password                                                              |                         |
| `CRON_INTERVAL`   | Amount of time in Minutes to Check Incoming Mail                            | `10`                    |
| `DB_HOST`         | Host or container name of MariaDB Server e.g. `osticket-db`                 |                         |
| `DB_PORT`         | MariaDB Port                                                                | `3306`                  |
| `DB_NAME`         | MariaDB Database name e.g. `osticket`                                       |                         |
| `DB_USER`         | MariaDB Username for above Database e.g. `osticket`                         |                         |
| `DB_PASS`         | MariaDB Password for above Database e.g. `password`                         |                         |
| `DB_PREFIX`       | Prefix for Tables                                                           | `ost_`                  |
| `SMTP_HOST`       | SMTP Host                                                                   | `postfix`               |
| `SMTP_PORT`       | SMTP Host Port                                                              | `25`                    |
| `SMTP_FROM`       | SMTP From Address                                                           | `osticket@hostname.com` |
| `SMTP_TLS`        | Should TLS be used (`0`=no `1`=yes)                                         | `1`                     |
| `SMTP_USER`       | SMTP Authentication user                                                    |                         |
| `SMTP_PASS`       | SMTP Authentication password                                                |                         |

### Networking

The following ports are exposed.

| Port | Description |
| ---- | ----------- |
| `80` | HTTP        |

* * *
## Maintenance

### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

``bash
docker exec -it (whatever your container name is) bash
``
## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for personalized support
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.

## References

* https://osticket.org

