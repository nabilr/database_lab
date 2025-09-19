# Simple MySQL setup for Advanced Tutorial
FROM mysql:8.0

# Database configuration
ENV MYSQL_ROOT_PASSWORD=advancedpass
ENV MYSQL_DATABASE=university_advanced

# Copy tutorial files
COPY advanced-schema.sql /docker-entrypoint-initdb.d/01-schema.sql
COPY advanced-schema-extensions.sql /docker-entrypoint-initdb.d/02-extensions.sql
COPY advanced-indexes.sql /docker-entrypoint-initdb.d/03-indexes.sql

EXPOSE 3306
