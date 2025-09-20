# Quiz 1 Practice Environment - MySQL Database with Employee Schema
FROM mysql:8.0

# Environment configuration
ENV MYSQL_ROOT_PASSWORD=quiz1practice
ENV MYSQL_DATABASE=quiz1_practice
ENV MYSQL_USER=student
ENV MYSQL_PASSWORD=student123

# Copy SQL files to initialization directory
# Files are executed in alphabetical order
COPY employee-database-schema.sql /docker-entrypoint-initdb.d/01-schema.sql
COPY 01-joins-and-filtering-practice.sql /docker-entrypoint-initdb.d/02-joins-practice.sql
COPY 02-integrity-constraints-practice.sql /docker-entrypoint-initdb.d/03-constraints-practice.sql
COPY 03-multiple-choice-practice.sql /docker-entrypoint-initdb.d/04-multiple-choice-practice.sql
COPY 04-challenge-questions-practice.sql /docker-entrypoint-initdb.d/05-challenge-practice.sql

# MySQL configuration for better performance and compatibility
RUN echo "[mysqld]" >> /etc/mysql/conf.d/custom.cnf && \
    echo "innodb_buffer_pool_size=256M" >> /etc/mysql/conf.d/custom.cnf && \
    echo "max_connections=200" >> /etc/mysql/conf.d/custom.cnf && \
    echo "sql_mode=STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO" >> /etc/mysql/conf.d/custom.cnf && \
    echo "innodb_file_per_table=1" >> /etc/mysql/conf.d/custom.cnf

# Expose MySQL port
EXPOSE 3306

# Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
    CMD mysqladmin ping -h localhost -u root -p$MYSQL_ROOT_PASSWORD || exit 1

# Labels for documentation
LABEL maintainer="Database Lab Tutorial"
LABEL description="Quiz 1 Practice Environment with Employee Database"
LABEL version="1.0"
