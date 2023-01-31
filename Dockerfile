FROM docker.io/tiredofit/nginx-php-fpm:debian-7.4-bullseye
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

### Default Runtime Environment Variables
ENV OSTICKET_VERSION=v1.15.4 \
    DB_PREFIX=ost_ \
    DB_PORT=3306 \
    CRON_INTERVAL=10 \
    MEMCACHE_PORT=11211 \
    PHP_ENABLE_CURL=TRUE \
    PHP_ENABLE_FILEINFO=TRUE \
    PHP_ENABLE_IMAP=TRUE \
    PHP_ENABLE_LDAP=TRUE \
    PHP_ENABLE_MYSQLI=TRUE \
    PHP_ENABLE_SESSION=TRUE \
    PHP_ENABLE_CREATE_SAMPLE_PHP=FALSE \
    PHP_ENALBLE_ZIP=TRUE \
    NGINX_SITE_ENABLED=osticket \
    NGINX_WEBROOT=/www/osticket \
    ZABBIX_AGENT_TYPE=classic \
    IMAGE_NAME="tiredofit/osticket" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-osticket/"

### Dependency Installation
RUN set -x && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
                  git \
                  libldap-common \
                  openssl \
                  php${PHP_BASE}-memcached \
                  tar \
                  wget \
                  zlib1g \
                  && \
    \
### Download & Prepare OSTicket for Install
    git clone  https://github.com/osTicket/osTicket /usr/src/osticket && \
    git -C /usr/src/osticket checkout ${OSTICKET_VERSION} && \
    mkdir -p /assets/install && \
    mv /usr/src/osticket/* /assets/install && \
    chown -R nginx:www-data /assets/install && \
    chmod -R a+rX /assets/install/ && \
    chmod -R u+rw /assets/install/ && \
    mv /assets/install/setup /assets/install/setup_hidden && \
    chown -R root:root /assets/install/setup_hidden && \
    chmod 700 /assets/install/setup_hidden && \
    \
# Setup Official Plugins
    git clone -b develop https://github.com/osTicket/osTicket-plugins /usr/src/plugins
RUN set -x && \    cd /usr/src/plugins && \
    php make.php hydrate && \
    for plugin in $(find * -maxdepth 0 -type d ! -path doc ! -path lib); do cp -r ${plugin} /assets/install/include/plugins; done; \
    cp -R /usr/src/plugins/*.phar /assets/install/include/plugins/ && \
    cd / && \
    \
# Add Community Plugins
    ## Archiver
    git clone https://github.com/clonemeagain/osticket-plugin-archiver /assets/install/include/plugins/archiver && \
    ## Attachment Preview
    git clone https://github.com/clonemeagain/attachment_preview /assets/install/include/plugins/attachment-preview && \
    ## Auto Closer
    git clone https://github.com/clonemeagain/plugin-autocloser /assets/install/include/plugins/auto-closer && \
    ## Fetch Note
    git clone https://github.com/bkonetzny/osticket-fetch-note /assets/install/include/plugins/fetch-note && \
    ## Field Radio Buttons
    git clone https://github.com/Micke1101/OSTicket-plugin-field-radiobuttons /assets/install/include/plugins/field-radiobuttons && \
    ## Mentioner
    git clone https://github.com/clonemeagain/osticket-plugin-mentioner /assets/install/include/plugins/mentioner && \
    ## Multi LDAP Auth
    git clone https://github.com/philbertphotos/osticket-multildap-auth /assets/install/include/plugins/multi-ldap && \
    mv /assets/install/include/plugins/multi-ldap/multi-ldap/* /assets/install/include/plugins/multi-ldap/ && \
    rm -rf /assets/install/include/plugins/multi-ldap/multi-ldap && \
    ## Prevent Autoscroll
    git clone https://github.com/clonemeagain/osticket-plugin-preventautoscroll /assets/install/include/plugins/prevent-autoscroll && \
    ## Rewriter
    git clone https://github.com/clonemeagain/plugin-fwd-rewriter /assets/install/include/plugins/rewriter && \
    ## Slack
    git clone https://github.com/clonemeagain/osticket-slack /assets/install/include/plugins/slack && \
    ## Teams (Microsoft)
    git clone https://github.com/ipavlovi/osTicket-Microsoft-Teams-plugin /assets/install/include/plugins/teams && \
    \
### Log Miscellany Installation
    touch /var/log/msmtp.log && \
    chown nginx:www-data /var/log/msmtp.log && \
   \
## Cleanup
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /usr/src/* && \
    rm -rf /root/.composer/cache

### Add Files
COPY install /
