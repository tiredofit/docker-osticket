ARG DISTRO=debian
ARG DISTRO_VARIANT=bullseye
ARG PHP_VERSION=8.1

FROM docker.io/tiredofit/nginx-php-fpm:${PHP_VERSION}-${DISTRO}-${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG OSTICKET_VERSION
ARG OSTICKET_PLUGINS_VERSION

ENV OSTICKET_VERSION=${OSTICKET_VERSION:-"v1.17.3"} \
    OSTICKET_PLUGINS_VERSION=${OSTICKET_PLUGINS_VERSION:-"develop"} \
    OSTICKET_REPO_URL=${OSTICKET_REPO_URL:-"https://github.com/osticket/osticket"} \
    OSTICKET_PLUGINS_REPO_URL=${OSTICKET_REPO_URL:-"https://github.com/osTicket/osTicket-plugins"} \
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
RUN source /assets/functions/00-container && \
    set -x && \
    package update && \
    package upgrade && \
    package install  \
                    git \
                    libldap-common \
                    openssl \
                    php${PHP_VERSION}-memcached \
                    tar \
                    wget \
                    zlib1g \
                    && \
    \
### Download & Prepare OSTicket for Install
    clone_git_repo "${OSTICKET_REPO_URL}" "${OSTICKET_VERSION}" /assets/install && \
    chown -R "${NGINX_USER}":"${NGINX_GROUP}" /assets/install && \
    chmod -R a+rX /assets/install/ && \
    chmod -R u+rw /assets/install/ && \
    mv /assets/install/setup /assets/install/setup_hidden && \
    chown -R root:root /assets/install/setup_hidden && \
    chmod 700 /assets/install/setup_hidden && \
    \
# Setup Official Plugins
    clone_git_repo "${OSTICKET_PLUGINS_REPO_URL}" "${OSTICKET_PLUGINS_VERSION}" /usr/src/plugins && \
    php make.php hydrate && \
    for plugin in $(find * -maxdepth 0 -type d ! -path doc ! -path lib); do cp -r ${plugin} /assets/install/include/plugins; done; \
    cp -R /usr/src/plugins/*.phar /assets/install/include/plugins/ && \
    cd / && \
    \
# Add Community Plugins
    ## Archiver
    clone_git_repo https://github.com/clonemeagain/osticket-plugin-archiver master /assets/install/include/plugins/archiver && \
    ## Attachment Preview
    clone_git_repo  https://github.com/clonemeagain/attachment_preview master /assets/install/include/plugins/attachment-preview && \
    ## Auto Closer
    clone_git_repo  https://github.com/clonemeagain/plugin-autocloser master /assets/install/include/plugins/auto-closer && \
    ## Fetch Note
    clone_git_repo  https://github.com/bkonetzny/osticket-fetch-note master /assets/install/include/plugins/fetch-note && \
    ## Field Radio Buttons
    clone_git_repo  https://github.com/Micke1101/OSTicket-plugin-field-radiobuttons master /assets/install/include/plugins/field-radiobuttons && \
    ## Mentioner
    clone_git_repo  https://github.com/clonemeagain/osticket-plugin-mentioner master /assets/install/include/plugins/mentioner && \
    ## Multi LDAP Auth
    clone_git_repo  https://github.com/philbertphotos/osticket-multildap-auth master /assets/install/include/plugins/multi-ldap && \
    mv /assets/install/include/plugins/multi-ldap/multi-ldap/* /assets/install/include/plugins/multi-ldap/ && \
    rm -rf /assets/install/include/plugins/multi-ldap/multi-ldap && \
    ## Prevent Autoscroll
    clone_git_repo  https://github.com/clonemeagain/osticket-plugin-preventautoscroll master /assets/install/include/plugins/prevent-autoscroll && \
    ## Rewriter
    clone_git_repo  https://github.com/clonemeagain/plugin-fwd-rewriter master /assets/install/include/plugins/rewriter && \
    ## Slack
    clone_git_repo  https://github.com/clonemeagain/osticket-slack master /assets/install/include/plugins/slack && \
    ## Teams (Microsoft)
    clone_git_repo  https://github.com/ipavlovi/osTicket-Microsoft-Teams-plugin master /assets/install/include/plugins/teams && \
    \
    ### Log Miscellany Installation
    touch /var/log/msmtp.log && \
    chown "${NGINX_USER}":"${NGINX_GROUP}" /var/log/msmtp.log && \
   \
## Cleanup
    package cleanup && \
    rm -rf \
            /root/.composer \
            /tmp/* \
            /usr/src/*

COPY install /
