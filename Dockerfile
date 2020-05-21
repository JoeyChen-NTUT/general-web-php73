FROM php:7.3-apache

RUN curl -o /usr/share/ca-certificates/NTUT_CA.pem https://cnc.ntut.edu.tw/var/file/4/1004/img/1183/NTUT_Computer_And_Network_Center_Root_CA.cer
RUN update-ca-certificates --fresh

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt clean
RUN apt update
RUN apt install -y apt-utils libxrender1 libfontconfig1 libxext6 git libzip-dev
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ENV MAX_EXECUTION_TIME 30
ENV UPLOAD_MAX_FILESIZE 2M
ENV POST_MAX_SIZE 8M
ENV MEMORY_LIMIT 128M
ENV DATE_TIMEZONE asia/taipei
ENV MAX_FILE_UPLOADS 20
ENV MAX_INPUT_TIME 60

#modify php.ini for env require
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
RUN sed -i -e 's/max_execution_time = 30/max_execution_time = ${MAX_EXECUTION_TIME}/g' /usr/local/etc/php/php.ini && \
    sed -i -e 's/upload_max_filesize = 2M/upload_max_filesize = ${UPLOAD_MAX_FILESIZE}/g' /usr/local/etc/php/php.ini && \
    sed -i -e 's/post_max_size = 8M/post_max_size = ${POST_MAX_SIZE}/g' /usr/local/etc/php/php.ini && \
    sed -i -e 's/memory_limit = 128M/memory_limit = ${MEMORY_LIMIT}/g' /usr/local/etc/php/php.ini && \
    sed -i -e 's/;date.timezone =/date.timezone = ${DATE_TIMEZONE}/g' /usr/local/etc/php/php.ini && \
    sed -i -e 's/max_file_uploads = 20/max_file_uploads = ${MAX_FILE_UPLOADS}/g' /usr/local/etc/php/php.ini && \
    sed -i -e 's/max_input_time = 60/max_input_time = ${MAX_INPUT_TIME}/g' /usr/local/etc/php/php.ini

ENV PHP_EXT
#install mysqli extensions
RUN docker-php-ext-install ${PHP_EXT} && docker-php-ext-enable ${PHP_EXT}

#enable mods
RUN a2enmod rewrite
