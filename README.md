# Ranking points

# Installation notes (local development)

1. Set up mongodb. 
2. Install Ruby, preferably with RVM (https://rvm.io/)
2. Clone repository
3. Inside the application folder, run
  
  bundle install
  unicorn -p 3000

4. To create a ranking entry, do POST /aula/1/exercicio/1 {user_id: 1, points: 2}
5. To retrieve a ranking path, do GET /aula/1/exercicio/1

# Installation notes (docker local)

To run with docker, use

1. Run a mongo image

2. Run sudo docker run -p 3000:3000 --link <you_mongo_name>:mongo mesalva/ranking_points

3. Try it!!
