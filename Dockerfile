FROM ruby:2.2

#ENV RAILS_VERSION 4.2.5
ENV RAILS_ENV production
#--version "$RAILS_VERSION"
RUN gem install rails 

RUN git clone https://github.com/mesalva/ranking_points
WORKDIR ranking_points
RUN git checkout docker_composer
RUN bundle install
EXPOSE 3000

CMD git pull origin docker_composer && RAILS_ENV=production bundle install && RAILS_ENV=production unicorn -p 3000