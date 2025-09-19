# Simple MySQL setup for Foundations Tutorial
FROM mysql:8.0

# Basic configuration
ENV MYSQL_ROOT_PASSWORD=foundationspass
ENV MYSQL_DATABASE=simple_school

# Copy tutorial files
COPY database-creation.sql /docker-entrypoint-initdb.d/

EXPOSE 3306
