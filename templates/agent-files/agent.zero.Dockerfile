FROM jetbrains/teamcity-agent:2024.03

WORKDIR /home/buildagent

# AWS CLI & CREDENTIALS
COPY secrets/.aws /home/buildagent/.aws
COPY secrets/.aws /root/.aws

RUN whoami
RUN pwd
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip

USER root
RUN ./aws/install -i /usr/local/aws-cli -b /usr/local/bin
RUN /usr/local/bin/aws --version

# SSH KEYS TO AUTH AS TEAMCITY AGENT
USER root
RUN mkdir /root/.ssh
COPY ssh_key/teamcity /root/.ssh/id_rsa
COPY ssh_key/teamcity.pub /root/.ssh/id_rsa.pub
RUN chown root:root /root/.ssh/id_rsa

# INSTALL ANSIBLE
ENV ANSIBLE_HOST_KEY_CHECKING False
USER root
RUN apt-get update && apt-get install ansible -y && apt-get clean

# UPGRADE NODEJS
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && apt-get clean

# INSTALL YARN
USER root
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn -y && apt-get clean
RUN yarn set version stable && yarn set version latest

# INSTALL FIREBASE CLI
RUN npm install -g firebase-tools

# INSTALL PHP
USER root
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get update && apt-get install -y wget curl && apt-get clean

RUN apt-get update && apt-get install -y \
    autoconf \
    dpkg-dev \
    file \
    g++ \
    gcc \
    libc-dev \
    make \
    pkg-config \
    re2c \
    && apt-get clean

RUN apt-get update && apt-get install -y \
    ca-certificates \
    xz-utils \
    sudo \
    unzip \
    python \
    apt-transport-https \
    lsb-release \
    cron \
    multitail \
    nano \
    supervisor \
    nodejs \
    htop \
    rename \
    && apt-get clean

ARG PHP_VERSION=8.2
RUN apt-get update && apt-get install -y \
    php${PHP_VERSION}-dev \
    php-pear \
    redis \
    openssl \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-common \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-amqp \
    php${PHP_VERSION}-mongodb \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-redis \
    php${PHP_VERSION}-opcache \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-soap \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-xdebug \
    php-excimer \
    && apt-get clean

RUN apt-get purge php8.3\* -y

# INSTALL COMPOSER
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer

RUN composer -V
RUN composer self-update

#COPY buildAgent.properties /data/teamcity_agent/conf/buildAgent.properties

# Done!
USER buildagent
