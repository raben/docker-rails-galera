#!/bin/bash

VOLUME_HOME=$HOME/$NAME

echo " -> Installation detected in $VOLUME_HOME"
echo " -> Installing Rails Application"
~/.rbenv/shims/rails new $VOLUME_HOME -d mysql
cd $VOLUME_HOME
sed -i -r "s/# gem 'therubyracer'/gem 'therubyracer'/i" Gemfile
sed -i -r "s/# gem 'unicorn'/gem 'unicorn'/i" Gemfile
sed -i -r "s/  host: localhost/  host: master/i" config/database.yml
sed -i -r "s/  username: root/  username: rw/i" config/database.yml
sed -i -r "s/  password:/  password: pass/i" config/database.yml
~/.rbenv/shims/bundle install
mv /tmp/unicorn.rb $VOLUME_HOME/config/
mv /tmp/unicorn.rake $VOLUME_HOME/lib/tasks/
mkdir -p $VOLUME_HOME/tmp/pids
mkdir -p $VOLUME_HOME/tmp/sockets
chmod -R 0777 $VOLUME_HOME/log
chmod -R 0777 $VOLUME_HOME/tmp
~/.rbenv/shims/rake db:migrate
~/.rbenv/shims/rake db:setup
echo " -> Done!"
