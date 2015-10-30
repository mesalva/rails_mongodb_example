FROM ubuntu:latest

RUN apt-get update -q
RUN apt-get install -qy curl --fix-missing
RUN apt-get install -qy git --fix-missing

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.0.list
RUN apt-get update -q
RUN apt-get install -y mongodb-org
RUN mkdir -p /data/db
RUN mongod --repair
RUN service mongod restart
RUN ps aux | grep mongo
RUN netstat -lp

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN /bin/bash -c -l 'source /etc/profile.d/rvm.sh'
RUN /bin/bash -c -l 'rvm requirements'
RUN /bin/bash -c -l 'rvm install 2.2.1'
RUN /bin/bash -c -l 'gem install bundler --no-ri --no-rdoc'
RUN /bin/bash -c -l 'gem install rails --no-ri --no-rdoc'
RUN /bin/bash -c -l  'gem install rake'
RUN apt-get install -qy pkg-config
RUN /bin/bash -c -l 'bundle config path "$HOME/bundler"'
RUN git clone https://github.com/mesalva/ranking_points
WORKDIR ranking_points
RUN git checkout develop
RUN /bin/bash -c -l 'bundle install --path vendor/cache'
RUN /bin/bash -c -l 'rake test'
EXPOSE 3000
CMD mongod --fork --logpath "/var/log/mongo.log"
CMD /bin/bash -c -l 'source /etc/profile.d/rvm.sh && git pull origin master && HOME=/ranking_points bundle update && HOME=/redmine bundle install --path vendor/cache && HOME=/ranking_points rake db:migrate && HOME=/ranking_points rails s'