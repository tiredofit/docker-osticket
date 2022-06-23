## 3.4.1 2022-06-23 <dave at tiredofit dot ca>

   ### Added
      - Support tiredofit/nginx:6.0.0 and tiredofit/nginx-php-fpm:7.0.0 changes


## 3.4.0 2021-11-23 <dave at tiredofit dot ca>

   ### Added
      - OSTIcket 1.15.4
      - Debian Bullseye base


## 3.3.3 2021-09-06 <eflukx@github>

   ### Fixed
      - Fix spelling mistake in Dockerfile for archiver plugin

## 3.3.2 2021-08-11 <cdhowie@github>

   ### Fixed
      - Clean NGINX_WEBROOT extra /www/ prefix from crontab

## 3.3.1 2021-08-11 <cdhowie@github>

   ### Changed
      - Cleanup composer cache
      - Cleanup Debian package cache to reduce image size 


## 3.3.0 2021-08-11 <dave at tiredofit dot ca>

   ### Added
      - Switch from Alpine to Debian base due to musl not supporting some functions OSTicket requires
      - Upgrade OSTicket to 1.15.3
      - PHP 7.4


## 3.2.1 2021-02-16 <leMail at github>

   ### Fixed
      - Removed erroneous argument in cron job


## 3.2.0 2020-06-15 <dave at tiredofit dot ca>

   ### Added
      - Update to support tiredofit/alpine 5.x.x base images


## 3.1.2 2020-01-02 <dave at tiredofit dot ca>

   ### Changed
      - Switch to php7-pecl-memcached


## 3.1.1 2020-01-02 <dave at tiredofit dot ca>

   ### Changed
      - Additional Changes to support new tiredofit/alpine base image


## 3.1.0 2019-12-29 <dave at tiredofit dot ca>

   ### Added
      - Support new tiredofit/nginx and tireofit/alpine base images


## 3.0.2 2019-12-17 <dave at tiredofit dot ca>

   ### Added
      - OSTicket 1.14.1
      - Refactored to support new tiredofit/nginx-php-fpm base image


## 3.0.1 2019-11-12 <dave at tiredofit dot ca>

* OSTicket 1.14-rc2

## 3.0 2019-09-12 <dave at tiredofit dot ca>

* Modernize Image
* Added many plugins
* OSTicket 1.14rc1
* PHP 7.3
* Alpine 3.10

## 2.8 2018-02-01 <dave at tiredofit dot ca>

* Pull sources from Github instead of mainwebsite
* Compile auth-ldap plugin

## 2.7 2018-02-01 <dave at tiredofit dot ca>

* Rebase

## 2.6 2017-10-05 <dave at tiredofit dot ca>

* Fix Broken Detection of new install

## 2.5 2017-08-29 <dave at tiredofit dot ca>

* Image Cleanup

## 2.4 2017-07-06 <dave at tiredofit dot ca>

* Added PHP_TIMEOUT

## 2.3 2017-07-03 <dave at tiredofit dot ca>

* Added PHP7-IMAP

## 2.2 2017-07-02 <dave at tiredofit dot ca>

* Build PHP7 Memcached Extension

## 2.1 2017-07-02 <dave at tiredofit dot ca>

* Sanity Checks in init scripts

## 2017-06-17 2.0 <dave at tiredofit dot ca>

* Rebase with nginx-php-fpm:7.0 with s6

## 2017-05-27 1.0 <dave at tiredofit dot ca>

* Production Stable
* Memcached Capable for Sessions
* Reset Admin Password if ENV Set upon Bootup


## 2017-05-27 0.9 <dave at tiredofit dot ca>

* Initial Release
* OSTicket 1.10
* Alpine:3.5
* PHP7
* Zabbix

