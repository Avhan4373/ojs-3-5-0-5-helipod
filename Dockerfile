FROM pkpofficial/ojs:3_5_0-5

# The official image runs as www-data. We need root inside the container so the
# entrypoint can fix the ownership of the mounted volumes (files/, public/)
# and then hand the process back to Apache (which binds port 80).
USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        default-mysql-client \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Custom OJS code: plugins (blocks/sidebarCards, themes/academic),
# templates, locale files and patched PKP classes.
COPY overlay/ /var/www/html/

# Runtime configuration template + bootstrap scripts.
COPY config.inc.php.template /opt/ojs/config.inc.php.template
COPY render-config.php /opt/ojs/render-config.php
COPY ojs-entrypoint.sh /usr/local/bin/ojs-entrypoint

# Sitbehind reverse proxy (Cloudflare tunnel / nginx): teruskan X-Forwarded-Proto
# ke PHP supaya OJS membuat URL https (mixed content) & cookie secure.
RUN printf '%s\n' \
        'SetEnvIf X-Forwarded-Proto "^https$" HTTPS=on' \
        'PassEnv HTTPS' \
        > /etc/apache2/conf-enabled/ojs-proxy.conf

RUN chmod +x /usr/local/bin/ojs-entrypoint \
    && mkdir -p /seed /var/www/html/files /var/www/html/public /var/www/html/cache \
    && chown -R www-data:www-data \
        /var/www/html/files \
        /var/www/html/public \
        /var/www/html/cache \
        /var/www/html/plugins \
        /var/www/html/templates \
        /var/www/html/lib/pkp/locale/id \
        /var/www/html/lib/pkp/classes

ENV PKP_CLI_INSTALL=0 \
    PKP_CMD=/usr/local/bin/pkp-start \
    SERVERNAME=ojs.helipod.app

EXPOSE 80
