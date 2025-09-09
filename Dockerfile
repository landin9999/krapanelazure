# PHP 8.2 with Apache
FROM php:8.2-apache

# Enable modules we need
RUN a2enmod rewrite headers

# Copy app
COPY . /var/www/html

# Apache runs on 80 in this image (good for Azure)
EXPOSE 80

# Healthcheck (optional; useful locally and in some orchestrators)
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD curl -f http://localhost/healthz || exit 1
