# freshdesk::dev
#
# additional resources for development and testing, where apache is used on the
# host to proxy ssl connections.

class freshdesk::dev {

  $pip_port = hiera('freshdesk::pip::port')

  ensure_packages(['apache2','ssl-cert'])

  file {'/opt/nectar/wildcard.crt':
    ensure => link,
    target => '/etc/ssl/certs/ssl-cert-snakeoil.pem',
  }
  file {'/opt/nectar/wildcard.key':
    ensure => link,
    target => '/etc/ssl/private/ssl-cert-snakeoil.key',
  }
  file {'/etc/apache2/conf-available/freshdesk.conf':
    content => template('freshdesk/dev/apache-rproxy.conf.erb'),
  }
  
  #enable things
  file {'/etc/apache2/mods-enabled/ssl.conf':
    ensure => link,
    target => '../mods-available/ssl.conf'
  }
  file {'/etc/apache2/mods-enabled/ssl.load':
    ensure => link,
    target => '../mods-available/ssl.load'
  }
  file {'/etc/apache2/mods-enabled/proxy.load':
    ensure => link,
    target => '../mods-available/proxy.load'
  }
  file {'/etc/apache2/mods-enabled/proxy_http.load':
    ensure => link,
    target => '../mods-available/proxy_http.load'
  }
  file {'/etc/apache2/mods-enabled/proxy.conf':
    ensure => link,
    target => '../mods-available/proxy.conf'
  }
  
}
