FROM php:7.4.27-cli-alpine3.15
# Set the correct timezone.
ENV TZ=Europe/Brussels

# Install bash, GIT and ssh
RUN apk update; \
    apk upgrade; \
    apk add bash git openssh zip unzip;

RUN apk add libpng-dev \
            libpq-dev \
            libzip-dev \
            libxml2-dev;

RUN docker-php-ext-install -j "$(nproc)" \
		gd \
		opcache \
		pdo_mysql \
		pdo_pgsql \
		zip \
		bcmath \
		soap \
	;


# We don't use 2.2 yet as it introduced a new challenge: https://getcomposer.org/allow-plugins
COPY --from=composer:2.1.14 /usr/bin/composer /usr/local/bin/composer
#COPY --from=composer:1.10.25 /usr/bin/composer /usr/local/bin/composer

COPY scripts/* /usr/local/bin/
COPY ssh/* /mount/ssh/

ENTRYPOINT ["/usr/local/bin/start.sh"]
