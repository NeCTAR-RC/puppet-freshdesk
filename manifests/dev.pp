# freshdesk::dev
#
# additional resources for development and testing, where apache is used on the
# host to proxy ssl connections.

class freshdesk::dev {

  $pip_port = $::freshdesk::pip::port

  ensure_packages(['ssl-cert'])

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
    ensure  => absent,
  }

}
