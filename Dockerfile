# Unified ASUP Dockerfile with configurable PHP version
ARG PHP_VERSION=8.2
FROM php:${PHP_VERSION}-cli-alpine

# Set the correct timezone (configurable)
ARG TIMEZONE=UTC
ENV TZ=${TIMEZONE}

# Package manager version
ARG COMPOSER_VERSION=2.5.8

# Base system packages
RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
        bash \
        git \
        openssh \
        zip \
        unzip \
        patch \
        curl \
        jq

# PHP extension dependencies
RUN apk add --no-cache \
        libpng-dev \
        libpq-dev \
        libzip-dev \
        libxml2-dev \
        icu-dev

# Install PHP extensions
RUN docker-php-ext-install -j "$(nproc)" \
        gd \
        opcache \
        pdo_mysql \
        pdo_pgsql \
        zip \
        bcmath \
        soap \
        intl

# Install Composer
COPY --from=composer:${COMPOSER_VERSION} /usr/bin/composer /usr/local/bin/composer

# Create application directories
RUN mkdir -p /code/api \
             /code/src \
             /code/app \
             /mount/ssh

# Install PHP dependencies for VCS APIs
WORKDIR /code/api
RUN composer require \
    "m4tthumphrey/php-gitlab-api:^11.10" \
    "knplabs/github-api:^3.0" \
    "guzzlehttp/guzzle:^7.4" \
    "http-interop/http-factory-guzzle:^1.2" \
    --no-dev --optimize-autoloader

# Copy application files
COPY scripts/start.sh /usr/local/bin/
COPY scripts/app/ /code/app/
COPY src/ /code/src/
COPY ssh/* /mount/ssh/

# Set correct permissions
RUN chmod +x /usr/local/bin/start.sh && \
    chmod -R 600 /mount/ssh/ || true

# Set working directory
WORKDIR /code/project

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD php --version || exit 1

# Default entrypoint
ENTRYPOINT ["/usr/local/bin/start.sh"]