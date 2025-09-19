# Simple MySQL setup for Intermediate Tutorial
FROM mysql:8.0

# Database configuration
ENV MYSQL_ROOT_PASSWORD=intermediatepass
ENV MYSQL_DATABASE=university_intermediate

# Copy tutorial files
COPY intermediate-schema.sql /docker-entrypoint-initdb.d/01-schema.sql
COPY intermediate-data.sql /docker-entrypoint-initdb.d/02-additional-data.sql

EXPOSE 3306
