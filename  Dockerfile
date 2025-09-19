# Simple, self-contained MySQL image with seed data
FROM mysql:8.0

# Use a strong real password in practice
ENV MYSQL_ROOT_PASSWORD=pass
ENV MYSQL_DATABASE=university

# Ensure UTF-8 everywhere
ENV TZ=UTC

# Copy schema + seed; MySQL auto-runs anything in this dir on first start
COPY init.sql /docker-entrypoint-initdb.d/01-init.sql