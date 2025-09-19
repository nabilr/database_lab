# database_lab
Database Lab



# From the folder that contains Dockerfile and init.sql
docker build -t university-mysql .
docker run --name uni-db -p 3306:3306 university-mysql




