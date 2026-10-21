#!/bin/bash
# OJS bootstrap for Helipod.
#
# 1. Renders config.inc.php from the template using environment variables.
# 2. Waits for the MySQL service and imports the database dump (once).
# 3. Restores the published files (public/journals) into the volume (once).
# 4. Fixes ownership of the mounted volumes and starts Apache.
set -euo pipefail

CONF=/var/www/html/config.inc.php
TPL=/opt/ojs/config.inc.php.template
SEED_DB_FILE="${SEED_DB_FILE:-/seed/ojs-db.sql.gz}"
SEED_PUBLIC_FILE="${SEED_PUBLIC_FILE:-/seed/ojs-public.tar.gz}"
LOCAL_BASE_URL="${LOCAL_BASE_URL:-http://localhost:8081}"

DB_HOST="${DB_HOST:?DB_HOST is required}"
DB_USER="${DB_USER:?DB_USER is required}"
DB_PASSWORD="${DB_PASSWORD:?DB_PASSWORD is required}"
DB_NAME="${DB_NAME:?DB_NAME is required}"
OJS_APP_KEY="${OJS_APP_KEY:?OJS_APP_KEY is required}"
OJS_BASE_URL="${OJS_BASE_URL:-https://${HELIPOD_PUBLIC_DOMAIN:?HELIPOD_PUBLIC_DOMAIN or OJS_BASE_URL is required}}"
OJS_TIME_ZONE="${OJS_TIME_ZONE:-Asia/Jakarta}"
OJS_REPOSITORY_ID="${OJS_REPOSITORY_ID:-ojs}"

# allowed_hosts: the host name of the public URL.
if [ -z "${OJS_ALLOWED_HOSTS:-}" ]; then
    OJS_ALLOWED_HOSTS="[\"$(echo "${OJS_BASE_URL}" | sed -E 's#^https?://([^/:]+).*#\1#')\"]"
fi

export OJS_APP_KEY OJS_BASE_URL OJS_TIME_ZONE OJS_ALLOWED_HOSTS OJS_REPOSITORY_ID
export DB_HOST DB_USER DB_PASSWORD DB_NAME

echo "[OJS] base_url  : ${OJS_BASE_URL}"
echo "[OJS] allowed   : ${OJS_ALLOWED_HOSTS}"
echo "[OJS] database  : ${DB_USER}@${DB_HOST}/${DB_NAME}"

# 1. config.inc.php
php /opt/ojs/render-config.php "${TPL}" "${CONF}"
chown www-data:www-data "${CONF}"
chmod 640 "${CONF}"

# 2. wait for the database
echo "[OJS] waiting for the database..."
db_ready=0
for _ in $(seq 1 120); do
    if MYSQL_PWD="${DB_PASSWORD}" mysql -h "${DB_HOST}" -u "${DB_USER}" "${DB_NAME}" \
        -N -e "SELECT 1" >/dev/null 2>&1; then
        db_ready=1
        break
    fi
    sleep 3
done

if [ "${db_ready}" != "1" ]; then
    echo "[OJS] database is not reachable, giving up"
    exit 1
fi

# 3. import the dump once (the volume keeps the data afterwards)
if MYSQL_PWD="${DB_PASSWORD}" mysql -h "${DB_HOST}" -u "${DB_USER}" "${DB_NAME}" \
    -N -e "SELECT 1 FROM journals LIMIT 1" >/dev/null 2>&1; then
    echo "[OJS] database already contains the journal, skipping the import"
else
    if [ -f "${SEED_DB_FILE}" ]; then
        echo "[OJS] importing the database dump from ${SEED_DB_FILE}"
        zcat "${SEED_DB_FILE}" \
            | sed "s#${LOCAL_BASE_URL}#${OJS_BASE_URL}#g" \
            | MYSQL_PWD="${DB_PASSWORD}" mysql -h "${DB_HOST}" -u "${DB_USER}" "${DB_NAME}"
        echo "[OJS] database import done"
    else
        echo "[OJS] no database dump found at ${SEED_DB_FILE}"
    fi
fi

# 4. restore the published files once
if [ ! -d /var/www/html/public/journals ] && [ -f "${SEED_PUBLIC_FILE}" ]; then
    echo "[OJS] restoring the published files from ${SEED_PUBLIC_FILE}"
    tar -xzf "${SEED_PUBLIC_FILE}" -C /var/www/html/public
fi

# 5. ownership of the volumes
mkdir -p /var/www/html/files /var/www/html/public /var/www/html/cache
chown -R www-data:www-data /var/www/html/files /var/www/html/public /var/www/html/cache

echo "[OJS] starting Apache"
exec /usr/local/bin/pkp-start
