#Per instal·lar Ruby executar les següents ordres:

sudo apt-get update
sudo apt-get --no-install-recommends install bash curl git patch bzip2
sudo apt-get --no-install-recommends install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev libgdbm-dev ncurses-dev automake libtool bison subversion pkg-config libffi-dev
curl -L https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install ruby-1.9.3-p385
#Gema per poder treballar amb accés a Internet
gem install mechanize

#Comprovar el funcionament:
echo "#! /usr/bin/env ruby">test.rb
echo "# encoding: utf-8" >> test.rb
echo "require 'pathname'" >> test.rb
echo "require 'mechanize'" >> test.rb
echo "abort 'Hola, entorn funcionant'" >> test.rb
ruby test.rb

#Ha de mostrar "Hola entorn funcionant"
rvm current
#Ha de mostrar la versió amb què es treballa en Ruby per exemple ruby-1.9.3-p385
