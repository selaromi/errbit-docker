FROM ruby:2.2.2
MAINTAINER Brian Olsen <brian@maven-group.org>

# Install packages for building ruby
RUN apt-get update -qq && apt-get install -y build-essential

ENV RACK_ENV production
ENV RAILS_ENV production
ENV USE_ENV true
ENV ERRBIT_EMAIL_FROM errbit@example.com

# Install bundler
RUN gem install bundler

# RUN /usr/sbin/useradd --create-home --home-dir /opt/errbit --shell /bin/bash errbit
# USER errbit

# Install errbit
RUN git clone https://github.com/errbit/errbit.git /opt/errbit/app

WORKDIR /opt/errbit/app
RUN bundle install --deployment
RUN bundle exec rake assets:precompile

ADD launch.bash /opt/launch.bash
EXPOSE 3000
ENTRYPOINT   ["/opt/launch.bash"]
CMD ["seed"]