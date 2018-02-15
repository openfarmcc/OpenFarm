#
# Image name: openfarm-webapp
#

FROM       ruby:2.3.3
MAINTAINER https://github.com/FarmBot/OpenFarm

ENV     PHANTOM_JS_VERSION 1.9.8

# Install phantomjs in /usr/local/bin
RUN     set -x; \
  curl -o /tmp/phantomjs.tar.bz2 -SL "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${PHANTOM_JS_VERSION}-linux-x86_64.tar.bz2" \
  && mkdir /tmp/phantomjs \
  && tar -xf /tmp/phantomjs.tar.bz2 -C /tmp/phantomjs --strip-components=1 \
  && mv /tmp/phantomjs/bin/phantomjs /usr/local/bin/ \
  && rm -rf /tmp/phantomjs* \
  && phantomjs --version

# Add the Gemfile and Gemfile.lock, then run `bundle install`
ADD     Gemfile /openfarm/Gemfile
ADD     Gemfile.lock /openfarm/Gemfile.lock
WORKDIR /openfarm

RUN     jobs="$(nproc)"; \
  set -x; \
  bundle config build.nokogiri --use-system-libraries \
  && bundle install --jobs "$jobs" --without development

# ADD code for production, this will be replaced by a volume during development
ADD     . /openfarm

# Environment is passed in from the host environment, disable the warning
RUN     touch /openfarm/config/app_environment_variables.rb

CMD [ "rails", "server", "-P", "tmp/pids/docker.pid" ]
EXPOSE  3000
