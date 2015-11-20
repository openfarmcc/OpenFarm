#-*- coding: utf-8 -*-
#!/usr/bin/env bash

echo "--- INSTALLING ELASTICSEARCH ---"

sudo apt-get install openjdk-7-jre-headless -y

wget https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.0.0/elasticsearch-2.0.0.deb
sudo dpkg -i elasticsearch-2.0.0.deb
sudo service elasticsearch start

echo "--- INSTALLING MONGODB - getting there! ---"

sudo apt-get -y install mongodb
sudo apt-get -y install libcurl3 libcurl3-gnutls libcurl4-openssl-dev

echo "--- OPEN FARM - getting there! ---"

cd /vagrant
rbenv global

gem install bundler
gem install activesupport -v '4.0.2'
rbenv rehash
bundle install
rake db:setup
echo "ENV['SECRET_KEY_BASE'] = '$(rake secret)'" >> config/app_environment_variables.rb
