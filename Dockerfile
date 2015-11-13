FROM rails:onbuild

RUN git clone https://github.com/mesalva/ranking_points
WORKDIR ranking_points
RUN git checkout docker_composer
RUN bundle install
EXPOSE 3000

CMD export RAILS_ENV=development && git pull origin docker_composer && bundle install && unicorn -p 3000