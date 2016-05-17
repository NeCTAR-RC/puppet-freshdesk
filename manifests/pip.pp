#freshdesk-pip application

# === Parameters
# [*package_ensure*] desired state of the package
# 
# [*service_ensure*] desired state of the service
# 
# [*jws_secret*] json web signature secret used for AAF authentication
# 
# [*aaf_login_url*] per application url given by AAF used to authenticate.
# Typically starts with https://rapid....aaf.edu.au/jwt
# 
# [*freshdesk_url*] login url for the freshdesk instance.
# 
# [*freshdesk_key*] shared token obtained from freshdesk security configuration
# screen
# 
# [*mongo_host*] mongo host to connect to
# 
# [*mongo_user*] mongo username. May not be required.
# 
# [*mongo_password*] mongo password. May not be required.
# 
# [*mongo_port*] Port to connect to mongodb. Defaults to 27017.
# 
# [*mongo_database*] mongodb database to use.
# 
# [*port*] Port that freshdesk-pip should listen on. If not specified, the app
# will start on its default port of 1337.
#
class freshdesk::pip(
  $package_ensure = 'present',
  $service_ensure = 'running',
  $jws_secret = undef,
  $aaf_login_url = undef,
  $freshdesk_url = undef,
  $freshdesk_key = undef,
  $mongo_host = undef,
  $mongo_user = false,
  $mongo_password = false,
  $mongo_port = '27017',
  $mongo_database = 'freshdesk-pip',
  $port = undef,
) {

  package {'freshdesk-pip':
    ensure => $package_ensure,
  }

  service {'freshdesk-pip':
    ensure => $service_ensure,
    enable => true,
  }

  file { '/opt/nectar/freshdesk-pip/config/env/production.js':
    content => template('freshdesk/pip.production.js.erb'),
    require => Package['freshdesk-pip'],
    notify  => Service['freshdesk-pip'],
  }
  file { '/opt/nectar/freshdesk-pip/config/connections.js':
    content => template('freshdesk/pip.connections.js.erb'),
    require => Package['freshdesk-pip'],
    notify  => Service['freshdesk-pip'],
  }

}


