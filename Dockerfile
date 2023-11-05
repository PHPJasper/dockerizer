# Use the latest version of Alpine
FROM alpine:latest

# Repository/Image Maintainer
LABEL maintainer="geekcom <danielrodrigues-ti@hotmail.com>"

# Install OpenJDK (Java Development Kit)
RUN echo "---> instaling open jdk" && \
    apk add --no-cache openjdk8 && \
    ln -sf "${JAVA_HOME}/bin/"* "/usr/bin/"

# Install PHP 8.2 and some common extensions
# Note: The PHP extensions available and their naming might vary depending on the repository and the PHP version.
# Please adjust the list of PHP extensions as per your requirement.
RUN apk add --no-cache \
    curl \
    bash \
    fontconfig \
    libxrender \
    libxext \
    imagemagick \
    nano \
    unzip \
    wget \
    sudo && \
    echo "---> Preparing and Installing PHP" && \
    apk add --update \
    php82 \
    php82-fpm \
    php82-opcache \
    php82-json \
    php82-mbstring \
    php82-pdo_sqlite \
    php82-pdo_mysql \
    php82-pdo_pgsql \
    php82-apcu \
    php82-bcmath \
    php82-curl \
    php82-openssl \
    php82-xml \
    php82-xmlreader \
    php82-phar \
    php82-pcntl \
    php82-intl \
    php82-dom \
    php82-xmlreader \
    php82-ctype \
    php82-session \
    php82-zip \
    php82-sodium \
    php82-gd \
    php82-mongodb \
    php82-tokenizer \
    php82-xmlwriter \
    php82-simplexml \
    php82-xdebug \
    # Additional PHP extensions can be added here
    && ln -s /usr/bin/php82 /usr/bin/php && \
    echo "---> Installing Composer" && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    echo "---> Cleaning up" && \
    rm -rf /tmp/* && \
    echo "---> Adding user" && \
    adduser -D -u 1000 phpjasper && \
    mkdir -p /var/www/app && \
    chown -R phpjasper:phpjasper /var/www

# Configure PHP-FPM
# Note: Customization might be required based on your application's needs
RUN sed -i "s/;daemonize = yes/daemonize = no/" /etc/php82/php-fpm.conf \
    && mkdir -p /run/php \
    && touch /run/php/php82-fpm.pid \
    && sed -i "s/user = nobody/user = phpjasper/" /etc/php82/php-fpm.d/www.conf \
    && sed -i "s/group = nobody/group = phpjasper/" /etc/php82/php-fpm.d/www.conf \
    && sed -i "s/listen.owner = nobody/listen.owner = phpjasper/" /etc/php82/php-fpm.d/www.conf \
    && sed -i "s/listen.group = nobody/listen.group = phpjasper/" /etc/php82/php-fpm.d/www.conf \
    && sed -i "s/;listen.mode = 0660/listen.mode = 0666/" /etc/php82/php-fpm.d/www.conf \
    && echo "phpjasper  ALL = ( ALL ) NOPASSWD: ALL" >> /etc/sudoers

RUN apk --no-cache add msttcorefonts-installer fontconfig --force-broken-world
RUN update-ms-fonts

# Define the running user
USER phpjasper

# Application directory
WORKDIR /var/www/app

# Environment variables
ENV PATH=/home/phpjasper/.composer/vendor/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    XDEBUG_ENABLED=false \
    TERM=xterm-256color \
    COLORTERM=truecolor \
    COMPOSER_PROCESS_TIMEOUT=1200 \
    JAVA_HOME=/usr/lib/jvm/default-jvm

# Default command
CMD ["/bin/bash"]
