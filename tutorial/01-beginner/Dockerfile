# Simple MySQL setup for Beginner Tutorial
FROM mysql:8.0

# Database configuration
ENV MYSQL_ROOT_PASSWORD=beginnerpass
ENV MYSQL_DATABASE=university_basic

# Copy tutorial files
COPY beginner-schema.sql /docker-entrypoint-initdb.d/

EXPOSE 3306
