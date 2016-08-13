#-*- coding: utf-8 -*-
#!/usr/bin/env bash

sudo apt-get update

sudo aptitude    update
sudo aptitude -y -q=2 upgrade
sudo aptitude install -y -q=2 build-essential
sudo aptitude install -y -q=2 cvs git-core

sudo apt-get -y -q=2 install git

sudo apt-get -y -q=2 install libcurl3 libcurl3-gnutls libcurl4-openssl-dev

echo "OKAY - GOING TO INSTALL OUR OWN THINGS NOW"

echo "--- INSTALLING RVM ---"

gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3

curl -sSL https://get.rvm.io | bash -s stable --quiet-curl --ruby=2.2.0

echo "--- INSTALLING RUBY 2.2.0 ---"

source /home/vagrant/.rvm/scripts/rvm

rvm reload
rvm --default use 2.2.0

echo "--- INSTALLING ELASTICSEARCH ---"

sudo apt-get -y -q=2 install openjdk-7-jre-headless -y

wget --quiet https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.0.0/elasticsearch-2.0.0.deb
sudo dpkg -i elasticsearch-2.0.0.deb
sudo service elasticsearch start

echo "--- INSTALLING MONGODB ---"

sudo apt-get -y -q=2 install mongodb

sudo mkdir /data/ && sudo mkdir /data/db/
sudo chown -R vagrant /data/db
sudo service mongodb start

echo "--- OPEN FARM - getting there! ---"

cd /vagrant

gem install bundler
gem install activesupport -v '4.0.2'

bundle install
rake db:setup
echo "ENV['SECRET_KEY_BASE'] = '$(rake secret)'" >> config/app_environment_variables.rb
