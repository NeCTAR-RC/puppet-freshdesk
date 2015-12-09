# == Class: freshdesk
#
# Installs Freshdesk PIP and OSID application. 
#
# === Parameters
#
#
# [*environment*]
#   The environment type: 'development', 'test', 'production'
#   Development will install localhost MongoDB, the rest will not.
# 
# [*server name*]
#   The FQDN hostname to use for this host. 
#
#
# === Authors
#
# <a href="https://github.com/shilob">Shilo Banihit</a>
#
#
class freshdesk(
  $environment              = 'development',
  $server_name              = 'localhost',
  $root_parent_dir          = '/opt/',
  $root_dir                 = '/opt/freshdesk',
  $apache_conf_dir          = '/etc/apache2',
  $freshdesk_home           = '/home/freshdesk',
  $pip_version              = '0.0.2',
  $osid_version             = '0.0.1',
  ) {
## Begin installation

  package { "apache2":
  } ->
  ## Configure apache
  exec {"Configure apache for '$server_name', enabling modules...": 
    command   => "a2enmod ssl proxy proxy_http",
    logoutput => true,
    path      => "/bin:/usr/bin:/usr/sbin:/usr/local/bin/:/sbin",
  } ->
  file { "Creating TLS directory...":
    path      => "${root_dir}-tls",
    ensure    => directory,
  } ->
  file { "${root_dir}-tls/server.crt": 
    source    => "${root_dir}-devops/tls/${server_name}.crt"
  } ->
  file { "${root_dir}-tls/server.key": 
    source    => "${root_dir}-devops/tls/${server_name}.key"
  } ->
  file { "${apache_conf_dir}/conf-available/freshdesk.conf": 
    source    => "${root_dir}-devops/apache/freshdesk.conf"
  } ->
  file { "${apache_conf_dir}/conf-enabled/freshdesk.conf": 
    ensure    => link,
    target    => "${apache_conf_dir}/conf-available/freshdesk.conf",
  } ->
  file { "/var/www/html/index.html": 
    source    => "${root_dir}-devops/apache/index.html",
    backup    => ".bak-orig",
  } ->
  ## Creating freshdesk user
  user { "Creating freshdesk user": 
    name      => 'freshdesk',
    ensure    => present,
    home      => $freshdesk_home,
    managehome=> true,
  } -> 
  ## Install tarballs and configure app...
  exec {"Unpacking PIP ${pip_version}...":
    cwd       => $root_parent_dir,
    command   => "tar xzf ${root_dir}-devops/bin/freshdesk-pip-${pip_version}.tar.gz -C /",
    path      => "/bin:/usr/bin:/usr/sbin:/usr/local/bin/:/sbin",
  } ->
  exec {"Unpacking OSID ${osid_version}...":
    cwd       => $root_parent_dir,
    command   => "tar xzf ${root_dir}-devops/bin/freshdesk-osid-${osid_version}.tar.gz -C /",
    path      => "/bin:/usr/bin:/usr/sbin:/usr/local/bin/:/sbin",
  } ->
  ## Creating services
  file {"/etc/init/freshdesk-pip.conf":
    source    => "${root_dir}-devops/upstart/${environment}-freshdesk-pip.conf"
  } ->
  file {"/etc/init/freshdesk-osid.conf":
    source    => "${root_dir}-devops/upstart/${environment}-freshdesk-osid.conf"
  } ->
  ## Creating LOGS / PID Directory
  file  {"/var/run/freshdesk":
    ensure    => directory,
    owner     => 'freshdesk',
    group     => 'freshdesk',
  } ->
  file {"/var/log/freshdesk":
    ensure    => directory,
    owner     => 'freshdesk',
    group     => 'freshdesk',
  } ->
  ## Copying logrotate 
  file {"/etc/logrotate.d/freshdesk":
    source    => "${root_dir}-devops/logrotate/freshdesk",
  } ->
  ## Copying app configuration
  file {"${root_dir}-pip/config/env/${environment}.js":
    source    => "${root_dir}-devops/pip-config/${server_name}.js",
    backup    => ".bak",
  } ->
  file {"${root_dir}-osid/config/env/${environment}.js":
    source    => "${root_dir}-devops/osid-config/${environment}.js",
    backup    => ".bak",
  } ->
  ## Installing stack
  package {"python-pip":
  } ->
  exec {"Installing Python Virtualenv":
    command   => "pip install ${root_dir}-devops/bin/virtualenv-13.1.0-py2.py3-none-any.whl",
    path      => "/bin:/usr/bin:/usr/sbin:/usr/local/bin/:/sbin",
  } ->
  exec {"Unpacking OS Wheelhouse":
    cwd       => $root_parent_dir,
    command   => "tar xzf ${root_dir}-devops/bin/os-client-1.5-wheelhouse.tar.gz -C /",
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
    source    => "${root_dir}-devops/openstackclient/compute/v2/server.py",
    owner     => 'freshdesk',
    group     => 'freshdesk',
  } ->
  ## Install NVM, Sails and Forever
  exec {"Unpacking NVM...": 
    command   => "tar xzf ${root_dir}-devops/bin/nvm-0.25.4.tar.gz -C /",
    path      => "/bin:/usr/bin:/usr/sbin:/usr/local/bin/:/sbin",
  }  ->
  file {"${freshdesk_home}/.bash_profile":
    source    => "${root_dir}-devops/bash/bash_profile",
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
