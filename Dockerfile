FROM ubuntu:latest

RUN apt-get update -q
RUN apt-get install -qy curl --fix-missing
RUN apt-get install -qy git --fix-missing

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
RUN /bin/bash -c -l 'bundle install --path vendor/cache'
EXPOSE 3000
CMD /bin/bash -c -l 'source /etc/profile.d/rvm.sh && git pull origin master && HOME=/ranking_points bundle update && HOME=/ranking_points bundle install --path vendor/cache && RAILS_ENV=production bundle exec unicorn -D -p 3000 -c config/unicorn.rb'