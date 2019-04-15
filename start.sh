#!/usr/bin/env bash

# OPCache mode.
if [[ $OPCACHE_MODE == "extreme" ]]; then
    # enable extreme caching for OPCache.
    echo "opcache.enable=1" | sudo tee -a /etc/php7/conf.d/00_opcache.ini > /dev/null
    echo "opcache.memory_consumption=512" | sudo tee -a /etc/php7/conf.d/00_opcache.ini > /dev/null
    echo "opcache.interned_strings_buffer=128" | sudo tee -a /etc/php7/conf.d/00_opcache.ini > /dev/null
    echo "opcache.max_accelerated_files=32531" | sudo tee -a /etc/php7/conf.d/00_opcache.ini > /dev/null
    echo "opcache.validate_timestamps=0" | sudo tee -a /etc/php7/conf.d/00_opcache.ini > /dev/null
    echo "opcache.save_comments=1" | sudo tee -a /etc/php7/conf.d/00_opcache.ini > /dev/null
    echo "opcache.fast_shutdown=0" | sudo tee -a /etc/php7/conf.d/00_opcache.ini > /dev/null

fi

if [[ $XDEBUG_ENABLED == true ]]; then
    sed -i "/;zend_extension=xdebug/c\zend_extension=xdebug" /etc/php7/conf.d/00_xdebug.ini
    sed -i "/;xdebug.remote_enable=1/c\xdebug.remote_enable=1" /etc/php7/conf.d/00_xdebug.ini
    sed -i "/;xdebug.remote_host=`/sbin/ip route|awk '/default/ { print $3 }'`/c\xdebug.remote_host=`/sbin/ip route|awk '/default/ { print $3 }'`" /etc/php7/conf.d/00_xdebug.ini
    sed -i "/;xdebug.remote_port=9001/c\xdebug.remote_port=9001" /etc/php7/conf.d/00_xdebug.ini
    sed -i "/;xdebug.remote_autostart=1/c\xdebug.remote_autostart=1" /etc/php7/conf.d/00_xdebug.ini
    sed -i "/;xdebug.remote_connect_back=1/c\xdebug.remote_connect_back=1" /etc/php7/conf.d/00_xdebug.ini
    sed -i "/;xdebug.cli_color=1/c\xdebug.cli_color=1" /etc/php7/conf.d/00_xdebug.ini
    sed -i "/;xdebug.show_local_vars=1/c\xdebug.show_local_vars=1" /etc/php7/conf.d/00_xdebug.ini
    sed -i "/;xdebug.idekey=phpjasper/c\xdebug.idekey=phpjasper" /etc/php7/conf.d/00_xdebug.ini
    sed -i "/;xdebug.scream=0/c\xdebug.scream=0" /etc/php7/conf.d/00_xdebug.ini
fis

# run the original command
exec "$@"
fi