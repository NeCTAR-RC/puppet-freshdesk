#/bin/bash
ENVSTR=$1
DOMAIN=$2
DEVOPS_DIR=/opt/freshdesk-devops/
PIP_DIR=/opt/freshdesk-pip
OSID_DIR=/opt/freshdesk-osid
TARGET_USER=freshdesk

## Install MongoDB 3.0.4
function mongo {
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
  echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
  apt-get update
  apt-get install -y mongodb-org=3.0.4 mongodb-org-server=3.0.4 mongodb-org-shell=3.0.4 mongodb-org-mongos=3.0.4 mongodb-org-tools=3.0.4
  echo "mongodb-org hold" | sudo dpkg --set-selections
  echo "mongodb-org-server hold" | sudo dpkg --set-selections
  echo "mongodb-org-shell hold" | sudo dpkg --set-selections
  echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
  echo "mongodb-org-tools hold" | sudo dpkg --set-selections
  service mongod start
}

## Install Nginx
function nginx {
  apt-get install -y nginx 
  cp $DEVOPS_DIR/nginx/conf.d/freshdesk.conf /etc/nginx/sites-available/freshdesk
  ln -s /etc/nginx/sites-available/freshdesk /etc/nginx/sites-enabled/freshdesk
  rm /etc/nginx/sites-enabled/default
  service nginx restart
}

function apache {
  apt-get install -y apache2
  a2enmod ssl proxy proxy_http
  # Install the TLS Certs
  mkdir -p /opt/freshdesk-tls/
  cp $DEVOPS_DIR/tls/${DOMAIN}.key /opt/freshdesk-tls/server.key
  cp $DEVOPS_DIR/tls/${DOMAIN}.crt /opt/freshdesk-tls/server.crt
  cp $DEVOPS_DIR/apache/freshdesk.conf /etc/apache2/conf-available/
  ln -s /etc/apache2/conf-available/freshdesk.conf /etc/apache2/conf-enabled/freshdesk.conf
  mv /var/www/html/index.html /var/www/html/index.old
  cp $DEVOPS_DIR/apache/index.html /var/www/html/index.html
}

function create_user {
  ## Create target user
  mkdir /home/freshdesk
  touch /home/freshdesk/.bash_profile
  useradd -d /home/freshdesk $TARGET_USER
  usermod -L $TARGET_USER

  chown -R $TARGET_USER:$TARGER_USER $PIP_DIR $OSID_DIR /home/freshdesk
}

function config_apps {
  ## Create services for the applications
  cp $DEVOPS_DIR/upstart/$ENVSTR-freshdesk-pip.conf /etc/init/freshdesk-pip.conf
  cp $DEVOPS_DIR/upstart/$ENVSTR-freshdesk-osid.conf /etc/init/freshdesk-osid.conf
  ## Create the logs / pid directory
  mkdir -p /var/run/freshdesk /var/log/freshdesk
  chown -R $TARGET_USER:$TARGET_USER /var/run/freshdesk /var/log/freshdesk
  ## Copy logrotate config
  cp $DEVOPS_DIR/logrotate/freshdesk /etc/logrotate.d/
  ## Copy app configuration
  cp $DEVOPS_DIR/pip-config/${DOMAIN}.js $PIP_DIR/config/env/${ENVSTR}.js
  cp $DEVOPS_DIR/osid-config/${ENVSTR}.js $OSID_DIR/config/env/${ENVSTR}.js
}

## Install Application Stacks
function install_stack {
apt-get install -y python-pip python-dev
pip install wrapt monotonic appdirs netifaces
pip install python-openstackclient
cat << EOF > /tmp/install_appstacks.sh
#/bin/bash
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.25.4/install.sh | bash
. ~/.nvm/nvm.sh
nvm install 0.12.7
nvm use 0.12.7
npm install sails -g
npm install forever -g

cd $PIP_DIR
npm install

cd $OSID_DIR
npm install

EOF

  chmod +x /tmp/install_appstacks.sh
  /bin/su - $TARGET_USER -c "/tmp/install_appstacks.sh"

  initctl reload-configuration
  service freshdesk-pip restart
  service freshdesk-osid restart
  service apache2 restart
}

function set_proxy {
  # set proxy 
  HASPROXY=`grep http_proxy /root/.bash_profile`
  RETURNVAL=$?
  if [ $RETURNVAL -ne 0 ]; then
    export http_proxy="http://wwwproxy.unimelb.edu.au:8000"
    export https_proxy=$http_proxy
    export HTTP_PROXY=$http_proxy
    export HTTPS_PROXY=$http_proxy

    printf "export http_proxy=\"$http_proxy\"\nexport https_proxy=\"$http_proxy\"\nexport HTTP_PROXY=\"$http_proxy\"\nexport HTTPS_PROXY=\"$http_proxy\"" >> /root/.bash_profile
  fi
}

function install_puppet {
  apt-get install puppet -y
  cp -R /opt/freshdesk-devops/puppet/freshdesk /usr/share/puppet/modules/

  puppet apply --debug -e "class {'freshdesk': environment=>'$ENVSTR', server_name=>'$DOMAIN'}"
}

set_proxy
#mongo
#nginx
#apache
#create_user
#config_apps
#install_stack
install_puppet