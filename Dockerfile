FROM tiredofit/nginx-php-fpm:5.6-latest
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

### Default Runtime Environment Variables
  ENV OSTICKET_VERSION=1.10.1 \
      PHP_ENABLE_IMAP=TRUE

### Dependency Installation
  RUN apk update && \
      apk add \
          git \
          libmemcached-libs \
          msmtp \
          openldap \
          openssl \
          tar \
          wget \
          zlib \
          && \

## Install Memcached Extenstion
      BUILD_DEPS=" \
      autoconf \
      build-base \
      cyrus-sasl-dev \
      libmemcached-dev \
      php5-dev \
      php5-pear \
      zlib-dev" && \

      apk add ${BUILD_DEPS} && \
      cd /tmp && \
      git clone -b REL2_0 https://github.com/php-memcached-dev/php-memcached && \
      cd /tmp/php-memcached && \
      phpize && \
      ./configure --with-php-config=/usr/bin/php-config --disable-memcached-sasl && \
      make && \
      make install && \
      echo 'extension=memcached.so' >> /etc/php5/conf.d/20_memcached.ini && \
      apk del ${BUILD_DEPS} && \
      rm -rf /var/cache/apk/* /tmp/* && \

### Download & Prepare OSTicket for Install
    mkdir -p /assets/osticket && \
    cd /assets/osticket && \
    wget -nv -O osTicket.zip https://github.com/osTicket/osTicket/releases/download/v${OSTICKET_VERSION}/osTicket-v${OSTICKET_VERSION}.zip && \
    unzip osTicket.zip && \
    rm osTicket.zip && \
    chown -R nginx:www-data /assets/osticket/upload/ && \
    chmod -R a+rX /assets/osticket/upload/ /assets/osticket/scripts/ && \
    chmod -R u+rw /assets/osticket/upload/ /assets/osticket/scripts/ && \
    mv /assets/osticket/upload/setup /assets/osticket/upload/setup_hidden && \
    chown -R root:root /assets/osticket/upload/setup_hidden && \
    chmod 700 /assets/osticket/upload/setup_hidden && \

# Download LDAP plugin
    cd /usr/src && \
    git clone https://github.com/osTicket/osTicket-plugins && \
    cd osTicket-plugins && \
    mv /etc/php5/conf.d/opcache.ini /tmp && \
    mv /etc/php5/php.ini /tmp && \
    php make.php hydrate && \
    php -dphar.readonly=0 make.php build auth-ldap && \
    mv /tmp/opcache.ini /etc/php5/conf.d/opcache.ini && \
    mv /tmp/php.ini /etc/php5/php.ini && \
    cp -R /usr/src/osTicket-plugins/auth-ldap.phar /assets/osticket/upload/include/plugins/ && \  
    cd / && \
    rm -rf /usr/src/osTicket-plugins && \
     
### Log Miscellany Installation
   touch /var/log/msmtp.log && \
   chown nginx:www-data /var/log/msmtp.log

### Add Files
   ADD install /
