#!/bin/sh
git pull origin master && RAILS_ENV=production bundle install && RAILS_ENV=production unicorn -p 3000