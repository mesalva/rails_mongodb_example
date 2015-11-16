FROM ruby:2.2

#ENV RAILS_VERSION 4.2.5
ENV RAILS_ENV production
RUN gem install rails 

RUN git clone https://github.com/mesalva/ranking_points
WORKDIR ranking_points
RUN git checkout docker_composer
RUN bundle install
RUN chmod 777 run_docker.sh
EXPOSE 3000
CMD ./run_docker.sh