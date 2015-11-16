#!/bin/sh
docker ps -a | awk '{ print $1,$2 }' | grep ranking | awk '{print $1 }' | xargs -I {} docker kill {}
docker ps -a | awk '{ print $1,$2 }' | grep mongo | awk '{print $1 }' | xargs -I {} docker kill {}

docker ps -a | awk '{ print $1,$2 }' | grep ranking | awk '{print $1 }' | xargs -I {} docker rm {}
docker ps -a | awk '{ print $1,$2 }' | grep mongo | awk '{print $1 }' | xargs -I {} docker rm {}

docker run --name some-mongo -d mongo
docker build -t mesalva/ranking_points .
docker run -p 3000:3000 -d --name ranking --link some-mongo:mongo  mesalva/ranking_points
wget http://localhost:3000/aula/1/exercicio/1
