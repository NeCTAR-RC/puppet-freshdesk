# == Class: puppet-freshdesk
#
# Installs Freshdesk PIP and OSID application. 
#
# === Authors
#
# <a href="https://github.com/shilob">Shilo Banihit</a>
#
#
class puppet-freshdesk(
  $root_parent_dir          = hiera('parent_dir', '/opt/'),
  $root_dir                 = hiera('root_dir','/opt/freshdesk'),
  $apache_conf_dir          = hiera('apache_conf_dir', '/etc/apache2'),
  $freshdesk_home           = hiera('freshdesk_home','/home/freshdesk'),
  $pip_version              = hiera('pip_version', '1.0.0'),
  $osid_version             = hiera('osid_version', '1.0.0'),
  $ssl_server_crt           = hiera('ssl_server_crt'),
  $ssl_server_key           = hiera('ssl_server_key'),
  $pip_jws_secret           = hiera('pip_jws_secret'),
  $pip_login_url            = hiera('pip_login_url'),
  $pip_freshdesk_login_url  = hiera('pip_freshdesk_login_url'),
  $pip_freshdesk_key        = hiera('pip_freshdesk_key'),
  $pip_mongo_host           = hiera('pip_mongo_host'),
  $pip_mongo_user           = hiera('pip_mongo_user'),
  $pip_mongo_pw             = hiera('pip_mongo_pw'),
  $pip_mongo_db             = hiera('pip_mongo_db'),
  $osid_showinstanceinfo    = hiera('osid_showinstanceinfo'),
  $osid_getinstancelist     = hiera('osid_getinstancelist'),
  $osid_freshdesk_host      = hiera('osid_freshdesk_host'),
  $osid_freshdesk_user      = hiera('osid_freshdesk_user'),
  $osid_basic_auth          = hiera('osid_basic_auth'),
  $osid_http_proxy          = hiera('osid_http_proxy'),
  
  ) {
## Begin installation
  package { "apache2":
  } ->
  ## Configure apache
  exec {"Configuring apache, enabling modules...": 
    command   => "a2enmod ssl proxy proxy_http",
    logoutput => true,
    path      => "/bin:/usr/bin:/usr/sbin:/usr/local/bin/:/sbin",
  } ->
  file { "Creating TLS directory...":
    path      => "${root_dir}-tls",
    ensure    => directory,
  } ->
  file { "${root_dir}-tls/server.crt": 
    content    => $ssl_server_crt,
  } ->
  file { "${root_dir}-tls/server.key": 
    content    => $ssl_server_key,
  } ->
  file { "${apache_conf_dir}/conf-available/freshdesk.conf": 
    source    => 'puppet:///modules/puppet-freshdesk/apache/freshdesk.conf',
  } ->
  file { "${apache_conf_dir}/conf-enabled/freshdesk.conf": 
    ensure    => link,
    target    => "${apache_conf_dir}/conf-available/freshdesk.conf",
  } ->
  file { "/var/www/html/index.html": 
    source   => 'puppet:///modules/puppet-freshdesk/apache/index.html',
    backup    => ".bak-orig",
  } ->
  ## Creating freshdesk user
  user { "Creating freshdesk user": 
    name      => 'freshdesk',
    ensure    => present,
    home      => $freshdesk_home,
    managehome=> true,
  } -> 
  file { "/tmp/freshdesk-pip-${pip_version}.tar.gz":
    source   => "puppet:///modules/puppet-freshdesk/bin/freshdesk-pip-${pip_version}.tar.gz",
  } ->
  file { "/tmp/freshdesk-osid-${osid_version}.tar.gz":
    source   => "puppet:///modules/puppet-freshdesk/bin/freshdesk-osid-${osid_version}.tar.gz",
  } ->
  ## Install tarballs and configure app...
  exec {"Unpacking PIP ${pip_version}...":
    cwd       => $root_parent_dir,
    command   => "tar xzf /tmp/freshdesk-pip-${pip_version}.tar.gz -C /",
    path      => "/bin:/usr/bin:/usr/sbin:/usr/local/bin/:/sbin",
  } ->
  exec {"Unpacking OSID ${osid_version}...":
    cwd       => $root_parent_dir,
    command   => "tar xzf /tmp/freshdesk-osid-${osid_version}.tar.gz -C /",
    path      => "/bin:/usr/bin:/usr/sbin:/usr/local/bin/:/sbin",
  } ->
  ########################################################
  ## Configuring PIP application
  ########################################################
  file_line { "Modifying PIP Config, JWS secret":
    match     => "jwsSecret",
    line      => "jwsSecret: '$pip_jws_secret',",
    path      => "${root_dir}-pip/config/env/production.js",
  } ->
  file_line { "Modifying PIP Config, Login URL":
    match     => "login_url",
    line      => "login_url: '$pip_login_url',",
    path      => "${root_dir}-pip/config/env/production.js",
  } ->
  file_line { "Modifying PIP Config, Freshdesk URL":
    match     => "url: ''",
    line      => "url:'$pip_freshdesk_login_url', // url:''",
    path      => "${root_dir}-pip/config/env/production.js",
  } ->
  file_line { "Modifying PIP Config, Freshdesk Key":
    match     => "key:",
    line      => "key: '$pip_freshdesk_key',",
    path      => "${root_dir}-pip/config/env/production.js",
  } ->
  file_line { "Modifying PIP Config, MongoDB Host":
    match     => "host:",
    line      => "host: '$pip_mongo_host',",
    path      => "${root_dir}-pip/config/env/production.js",
  } ->
  file_line { "Modifying PIP Config, MongoDB User":
    match     => "user:",
    line      => "user: '$pip_mongo_user',",
    path      => "${root_dir}-pip/config/env/production.js",
  } ->
  file_line { "Modifying PIP Config, MongoDB PW":
    match     => "password:",
    line      => "password: '$pip_mongo_pw',",
    path      => "${root_dir}-pip/config/env/production.js",
  } ->
  file_line { "Modifying PIP Config, MongoDB DB":
    match     => "database:",
    line      => "database: '$pip_mongo_db',",
    path      => "${root_dir}-pip/config/env/production.js",
  } ->
  ########################################################
  ## Configuring OSID application
  ########################################################
  file_line { "Modifying OSID Config, showInstanceInfo":
    match     => "nova --",
    line      => "mainCmd: '${osid_showinstanceinfo}'",
    path      => "${root_dir}-osid/config/env/production.js",
  } ->
  file_line { "Modifying OSID Config, getInstanceList":
    match     => "openstack server list",
    line      => "mainCmd: '${osid_getinstancelist}'",
    path      => "${root_dir}-osid/config/env/production.js",
  } ->
  file_line { "Modifying OSID Config, Freshdesk Host":
    match     => "hostname",
    line      => "hostname: '${osid_freshdesk_host}',",
    path      => "${root_dir}-osid/config/env/production.js",
  } ->
  file_line { "Modifying OSID Config, Freshdesk User":
    match     => "username:",
    line      => "username: '${osid_freshdesk_user}',",
    path      => "${root_dir}-osid/config/env/production.js",
  } ->
  file_line { "Modifying OSID Config, Authentication":
    match     => "authorization: '",
    line      => "authorization: 'Basic ${osid_basic_auth}',",
    path      => "${root_dir}-osid/config/env/production.js",
  } ->
  file_line { "Modifying OSID Config, HTTP Proxy":
    match     => "httpProxy: '",
    line      => "httpProxy: '${osid_http_proxy}',",
    path      => "${root_dir}-osid/config/env/production.js",
  } ->
  ########################################################
  ## Creating services
  ########################################################
  file {"/etc/init/freshdesk-pip.conf":
    source    => 'puppet:///modules/puppet-freshdesk/upstart/freshdesk-pip.conf',
  } ->
  file {"/etc/init/freshdesk-osid.conf":
    source    => 'puppet:///modules/puppet-freshdesk/upstart/freshdesk-osid.conf',
  } ->
  ## Copying logrotate 
  file {"/etc/logrotate.d/freshdesk":
    source    => "puppet:///modules/puppet-freshdesk/logrotate/freshdesk",
  } ->
  ## Installing stack
  package {"python-pip":
  } ->
  ########################################################
  ## Copying Binaries
  ########################################################
  file {"/tmp/virtualenv-13.1.0-py2.py3-none-any.whl":
    source    => 'puppet:///modules/puppet-freshdesk/bin/virtualenv-13.1.0-py2.py3-none-any.whl',
  } ->
  file {"/tmp/os-client-1.5-wheelhouse.tar.gz":
    source    => 'puppet:///modules/puppet-freshdesk/bin/os-client-1.5-wheelhouse.tar.gz',
  } ->
  file {"/tmp/nvm-0.25.4.tar.gz":
    source    => 'puppet:///modules/puppet-freshdesk/bin/nvm-0.25.4.tar.gz',
  } ->
  exec {"Installing Python Virtualenv":
    command   => "pip install /tmp/virtualenv-13.1.0-py2.py3-none-any.whl",
    path      => "/bin:/usr/bin:/usr/sbin:/usr/local/bin/:/sbin",
  } ->
  exec {"Unpacking OS Wheelhouse":
    cwd       => $root_parent_dir,
    command   => "tar xzf /tmp/os-client-1.5-wheelhouse.tar.gz -C /",
    path      => "/bin:/usr/bin:/usr/sbin:/usr/local/bin/:/sbin",
  } ->
  exec {"Installing OS Client":
    cwd       => '/home/freshdesk',
    command   => "virtualenv python/osenv && python/osenv/bin/pip install --use-wheel --no-index --find-links=${freshdesk_home}/os-client-1.5-wheelhouse python-openstackclient==1.5.0",
    path      => "/bin:/usr/bin:/usr/sbin:/usr/local/bin/:/sbin",
    user      => 'freshdesk'
  } ->
  ## Patch OS
  file {"Patching OS Client...":
    path      => "${freshdesk_home}/python/osenv/lib/python2.7/site-packages/openstackclient/compute/v2/server.py",
    source    => "puppet:///modules/puppet-freshdesk/openstackclient/compute/v2/server.py",
    owner     => 'freshdesk',
    group     => 'freshdesk',
  } ->
  ## Install NVM, Sails and Forever
  exec {"Unpacking NVM...": 
    command   => "tar xzf /tmp/nvm-0.25.4.tar.gz -C /",
    path      => "/bin:/usr/bin:/usr/sbin:/usr/local/bin/:/sbin",
  }  ->
  file {"${freshdesk_home}/.bash_profile":
    source    => "puppet:///modules/puppet-freshdesk/bash/bash_profile",
    owner     => 'freshdesk',
    group     => 'freshdesk',
  } ->
  ## Start services
  exec {"Starting services...": 
    command   => 'initctl reload-configuration && service freshdesk-pip restart && service freshdesk-osid restart && service apache2 restart',
    path      => "/bin:/usr/bin:/usr/sbin:/usr/local/bin/:/sbin",
  }
## End installation  
}
