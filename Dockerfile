#
# Image name: openfarm-webapp
#

FROM    ruby:2.2.0
MAINTAINER https://github.com/FarmBot/OpenFarm

ADD     Gemfile /openfarm/Gemfile
ADD     Gemfile.lock /openfarm/Gemfile.lock
WORKDIR /openfarm

RUN     set -x; \
        bundle config build.nokogiri --use-system-libraries \
        && bundle install --without development

# ADD code for production, this will be replaced by a volume during development
ADD     . /openfarm

# Environment is passed in from the host environment, disable the warning
RUN     touch /openfarm/config/app_environment_variables.rb

CMD     bundle exec rails server
EXPOSE  3000
