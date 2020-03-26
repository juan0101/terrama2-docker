#!/bin/bash

apt-get update

apt-get install -y software-properties-common
add-apt-repository -y ppa:apt-fast/stable
apt-get update
apt-get install -y apt-fast

apt-fast install -y qtcreator curl unzip locales supervisor wget libcurl3-dev libpython2.7-dev libproj-dev libgeos++-dev libssl-dev \
libxerces-c-dev screen doxygen graphviz gnutls-bin gsasl libgsasl7 libghc-gsasl-dev libgnutls-dev zlib1g-dev \
python-pip debhelper devscripts git build-essential ssh openssh-server libpq-dev sudo

pip install psycopg2

ssh-keygen -t rsa -b 4096 -C "terrama2-team@dpi.inpe.br" -N "" -f $HOME/.ssh/id_rsa

curl -sL https://deb.nodesource.com/setup_8.x | bash -

apt-fast install -y nodejs

export PATH=$PATH:/usr/lib/node_modules/npm/bin

npm install -g grunt-cli

export PATH=$PATH:/usr/lib/node_modules/grunt-cli/bin

rm -rf /var/lib/apt/lists/*