FROM php:8.5-apache

RUN apt-get update \
    && apt-get install -y --no-install-recommends libonig-dev libsqlite3-dev curl unzip \
    && docker-php-ext-install -j"$(nproc)" mbstring pdo_sqlite \
    && a2enmod rewrite headers expires \
    && rm -rf /var/lib/apt/lists/*

ENV APACHE_DOCUMENT_ROOT=/var/www/html/public \
    APP_URL=https://sense-of-style.ru

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

WORKDIR /var/www/html
COPY start.sh /usr/local/bin/sense-start

RUN curl --fail --location --retry 3 --retry-delay 3 \
        "https://filebin.net/sense-php85-1794733494/sense-php-hosting.zip" \
        --output /tmp/sense-php-hosting.zip \
    && echo "f8403818585403851213ffef9fa1add3e38fc8adf867a3f4b75de80316d179e6  /tmp/sense-php-hosting.zip" | sha256sum --check --strict \
    && unzip -q /tmp/sense-php-hosting.zip -d /var/www/html \
    && rm /tmp/sense-php-hosting.zip \
    && mkdir -p storage \
    && chown -R www-data:www-data storage \
    && chmod 775 storage

EXPOSE 3000
CMD ["sh", "/usr/local/bin/sense-start"]
