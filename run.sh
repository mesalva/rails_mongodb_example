git pull origin docker_composer && RAILS_ENV=production bundle install && RAILS_ENV=production unicorn -p 3000
