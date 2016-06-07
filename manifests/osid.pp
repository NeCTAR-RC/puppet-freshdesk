#freshdesk-osid application

# === Parameters
# [*package_ensure*] desired state of the package
#
# [*service_ensure*] desired state of the service
#
# [*freshdesk_authentication_string*] The base64 encoded version of the string found at the 'Requires Webhook'
# field of the Actions section of the "Dispatch'r" configuration in Freshdesk. The same value used in the
# Dispatch'r should be used in the Authentication field of the 'Observer'.
#
# [*freshdesk_hostname*] hostname where freshdesk is located.
#
# [*freshdesk_username *] freshdesk username
#
# [*freshdesk_password *] freshdesk password
#
# [*freshdesk_note_private *] Should the freshdesk not be private? Defaults to
# 'true'
#
# [*freshdesk_note_update *] Should the freshdesk not be updated? Defaults to
# 'true'
#
# [*log_level *] log level.
#
# [*show_binary*] Binary used to show information about an instance
#
# [*os_username*] Openstack username
#
# [*os_password*] Openstack password
#
# [*os_project_name*] Openstack project (tenant) name.
#
# [*os_auth_url*] Openstack authentication url (keystone endpoint)
#
# [*os_project_name*] Openstack project (tenant) name. Defaults to freshdesk.
#
# [*port*] Port that freshdesk-osid should listen on. Defaults to 1338
#
# [*show_binary*] Binary used to show information about the instance.

class freshdesk::osid(
  $package_ensure = 'present',
  $service_ensure = 'running',
  $freshdesk_authentication_string = undef,
  $freshdesk_hostname = undef,
  $freshdesk_username = undef,
  $freshdesk_password = undef,
  $freshdesk_note_private = 'true',
  $freshdesk_note_update = 'true',
  $log_level = undef,
  $os_username = 'freshdesk',
  $os_password = undef,
  $os_project_name = 'freshdesk',
  $os_auth_url = undef,
  $port = undef,
  $show_binary = 'nova',
) {

  package {'freshdesk-osid':
    ensure => $package_ensure,
  }

  service {'freshdesk-osid':
    ensure => $service_ensure,
  }

  file { '/opt/nectar/freshdesk-osid/config/env/production.js':
    content => template('freshdesk/osid.production.js.erb'),
    require => Package['freshdesk-osid'],
    notify  => Service['freshdesk-osid'],
  }
  file { '/opt/nectar/freshdesk-osid/config/log.js':
    content => template('freshdesk/osid.log.js.erb'),
    require => Package['freshdesk-osid'],
    notify  => Service['freshdesk-osid'],
  }

}


