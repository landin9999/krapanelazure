# PHP 8.2 with Apache
FROM php:8.2-apache

# Install curl for HEALTHCHECK
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl \
 && rm -rf /var/lib/apt/lists/*

# Enable rewrites + allow .htaccess to work
RUN a2enmod rewrite headers \
 && printf '<Directory "/var/www/html">\n  AllowOverride All\n  Require all granted\n</Directory>\n' \
      > /etc/apache2/conf-available/allow-htaccess.conf \
 && a2enconf allow-htaccess

# Copy app
WORKDIR /var/www/html
COPY . /var/www/html

# Simple health endpoint
RUN echo ok > /var/www/html/healthz

# Azure (and most PaaS) expect port 80 here; Apache already listens on 80
EXPOSE 80
CMD ["apache2-foreground"]

# Healthcheck (now curl exists and /healthz exists)
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD curl -fsS http://localhost/healthz || exit 1
