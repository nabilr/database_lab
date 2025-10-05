FROM mysql:8.0

# Set environment variables
ENV MYSQL_ROOT_PASSWORD=midtermpass
ENV MYSQL_DATABASE=midterm_review

# Copy schema and data files
COPY schema.sql /docker-entrypoint-initdb.d/01-schema.sql
COPY sample-data.sql /docker-entrypoint-initdb.d/02-sample-data.sql

# Expose MySQL port
EXPOSE 3306

# Set working directory
WORKDIR /docker-entrypoint-initdb.d
