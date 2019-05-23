cd src

1. Master server

docker build -f MasterServer.Dockerfile -t bodr1982/druid_master .
docker push bodr1982/druid_master
docker run -t -p 5432:5432 bodr1982/druid_master

2. Data server

docker build -f DataServer.Dockerfile -t bodr1982/druid_data .
docker push bodr1982/druid_data
docker run -t bodr1982/druid_data

3. Query Server

docker build -f QueryServer.Dockerfile -t bodr1982/druid_query .
docker push bodr1982/druid_query
docker run -t bodr1982/druid_query


Docker compose:
docker-compose up -d druidmaster druiddata1 druiddata2 druidquery
