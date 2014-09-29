#
# Image name: openfarm-webapp
#

FROM    ubuntu:trusty
MAINTAINER https://github.com/FarmBot/OpenFarm

ENV     DEBIAN_FRONTEND noninteractive

RUN     apt-get update && apt-get install -y \
            software-properties-common \
            python-software-properties && \
        apt-add-repository ppa:brightbox/ruby-ng

RUN     apt-get update && apt-get install -y \
            ruby2.1 \
            ruby2.1-dev \
            git \
            build-essential

RUN     gem install bundler
ADD     Gemfile /openfarm/Gemfile
ADD     Gemfile.lock /openfarm/Gemfile.lock
WORKDIR /openfarm

RUN     bundle install

# ADD code for production, this will be replaced by a volume during development
ADD     . /openfarm

# Environment is passed in from the host environment, disable the warning
RUN     touch /openfarm/config/app_environment_variables.rb

CMD     bundle exec rails server
EXPOSE  3000
