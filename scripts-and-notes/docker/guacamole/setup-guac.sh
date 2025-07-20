#!/bin/sh

# CONFIG — version and container names
JDBC_VERSION="1.5.4"
DB_NAME="guacamole"                   # match MYSQL_DATABASE
GUAC_DB_USER="guacamole"             # match MYSQL_USER
GUAC_MYSQL_CONTAINER="guacamole-mysql"
GUAC_WEB_CONTAINER="guacamole-web"
GUACAMOLE_HOME="/etc/guacamole"

# Prompt for MySQL root password (matches your .env)
printf "Enter MySQL root password: "
stty -echo
read DB_PASS
stty echo
echo ""

# Prompt for Guacamole DB user password (matches your .env)
printf "Enter password for Guacamole DB user ($GUAC_DB_USER): "
stty -echo
read GUAC_DB_PASS
stty echo
echo ""

# STEP 1 — Download JDBC module
wget "https://downloads.apache.org/guacamole/${JDBC_VERSION}/binary/guacamole-auth-jdbc-${JDBC_VERSION}.tar.gz" -O jdbc.tar.gz
mkdir -p guac-jdbc && tar -xzf jdbc.tar.gz -C guac-jdbc

# STEP 2 — Copy schema into MySQL container
doas docker cp guac-jdbc/guacamole-auth-jdbc-${JDBC_VERSION}/mysql/schema "$GUAC_MYSQL_CONTAINER":/

# STEP 3 — Ensure DB exists and apply schema
doas docker exec "$GUAC_MYSQL_CONTAINER" sh -c "mysql -u root -p$DB_PASS -e \"
CREATE DATABASE IF NOT EXISTS $DB_NAME;
GRANT ALL ON $DB_NAME.* TO '$GUAC_DB_USER'@'%';
FLUSH PRIVILEGES;
\""

doas docker exec "$GUAC_MYSQL_CONTAINER" sh -c "mysql -u root -p$DB_PASS $DB_NAME < /schema/001-create-schema.sql"
doas docker exec "$GUAC_MYSQL_CONTAINER" sh -c "mysql -u root -p$DB_PASS $DB_NAME < /schema/002-create-admin-user.sql"

# STEP 4 — Copy JDBC .jar to GUACAMOLE_HOME
doas mkdir -p "$GUACAMOLE_HOME/extensions"
doas cp "guac-jdbc/guacamole-auth-jdbc-${JDBC_VERSION}/mysql/guacamole-auth-jdbc-mysql-${JDBC_VERSION}.jar" "$GUACAMOLE_HOME/extensions/"

# STEP 5 — Append MySQL config to guacamole.properties
doas tee -a "$GUACAMOLE_HOME/guacamole.properties" >/dev/null <<EOF

# MySQL Authentication
mysql-hostname: $GUAC_MYSQL_CONTAINER
mysql-port: 3306
mysql-database: $DB_NAME
mysql-username: $GUAC_DB_USER
mysql-password: $GUAC_DB_PASS
EOF

# STEP 6 — Restart Guacamole web container
doas docker restart "$GUAC_WEB_CONTAINER"

echo "✅ Guacamole JDBC MySQL setup complete."
