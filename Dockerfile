FROM php:7.3-cli-bullseye

ENV PHALCON_VERSION v3.4.5

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-client \
    wget \
    git \
    musl-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxslt-dev \
    libffi-dev \
    libicu-dev \
    libzip-dev \
    libcurl4-openssl-dev \
    && docker-php-ext-install \
        pdo_mysql \
        mysqli \
        gd \
        exif \
        intl \
        xsl \
        json \
        soap \
        dom \
        zip \
        bcmath \
    && docker-php-source delete && rm -rf /var/lib/apt/lists/* 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN ( \
        curl -L -o /tmp/phalcon.tar.gz "https://github.com/phalcon/cphalcon/archive/refs/tags/${PHALCON_VERSION}.tar.gz" \
        && mkdir -p /tmp/phalcon \
        && tar -C /tmp/phalcon -zxvf /tmp/phalcon.tar.gz --strip 1 \
        && ( cd /tmp/phalcon/build && chmod +x ./install && ./install ) \
        && docker-php-ext-enable phalcon \
        && rm -rf /tmp/phalcon \
    )

CMD ["php", "-a"]
