FROM --platform=linux/amd64 php:7.4.27-cli-alpine3.15
# Set the correct timezone.
ENV TZ=Europe/Brussels

# Installations
RUN apk update; \
    apk upgrade; \
    apk add bash git openssh zip unzip patch;

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

# We use this library to invoke commands to Gitlab.
RUN mkdir -p /code/gitlab-api; \
    cd /code/gitlab-api; \
    composer require "m4tthumphrey/php-gitlab-api:^11.7" "guzzlehttp/guzzle:^7.4" "http-interop/http-factory-guzzle:^1.2";

# Remove .env file before docker build  if not developing locally.
# TODO: Build docker image with pipelines automatically and allways ignore .env file.
COPY scripts/start.sh .en[v] /usr/local/bin/
COPY scripts/app/ /code/app/
COPY ssh/* /mount/ssh/

ENTRYPOINT ["/usr/local/bin/start.sh"]
