#!/bin/sh
docker rm -f $(sudo docker ps -a | grep ranking)
docker rm -f $(sudo docker ps -a | grep mongo)
docker run --name some-mongo -d mongo
docker build -t mesalva/ranking_points .
docker run -p 3000:3000 -d --link some-mongo:mongo  mesalva/ranking_points
wget http://localhost:3000/aula/1/exercicio/1
