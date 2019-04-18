#-*- coding: utf-8 -*-
#!/usr/bin/env bash

echo "--- STARTING UP SERVER ---"

sudo service elasticsearch start
#PATH=~/home/vagrant/.rvm/gems/ruby-2.6.1@openfarm/bin/:$PATH
source /home/vagrant/.rvm/scripts/rvm

rvm reload

ELASTICSEARCH_URL='http://127.0.0.1:9201'

sleep 10

cd /vagrant

# bundle install
rails s -d -b 0.0.0.0

echo "--- SERVER STARTED ---"
