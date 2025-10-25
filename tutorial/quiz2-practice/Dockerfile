FROM mysql:8.0

# Set environment variables
ENV MYSQL_ROOT_PASSWORD=quiz2pass
ENV MYSQL_DATABASE=quiz2_practice

# Copy schema and data files
COPY schema.sql /docker-entrypoint-initdb.d/01-schema.sql
COPY sample-data.sql /docker-entrypoint-initdb.d/02-sample-data.sql
COPY questions.sql /docker-entrypoint-initdb.d/03-questions.sql
COPY solutions.sql /docker-entrypoint-initdb.d/04-solutions.sql

# Expose MySQL port
EXPOSE 3306

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD mysqladmin ping -h localhost -u root -p$MYSQL_ROOT_PASSWORD || exit 1
