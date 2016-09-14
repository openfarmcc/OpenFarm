#-*- coding: utf-8 -*-
#!/usr/bin/env bash

echo "--- STARTING UP SERVER ---"

sudo service elasticsearch start
#PATH=~/home/vagrant/.rvm/gems/ruby-2.2.5@openfarm/bin/:$PATH
source /home/vagrant/.rvm/scripts/rvm

rvm reload

ELASTICSEARCH_URL='http://127.0.0.1:9201'

cd /vagrant

# bundle install
rails s

echo "--- SERVER STARTED ---"
