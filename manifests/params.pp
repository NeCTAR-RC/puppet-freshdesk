# Parameters for puppet-freshdesk
#
class freshdesk::params {
  include ::openstacklib::defaults

  $group = 'freshdesk'

  case $::osfamily {
    'Debian': {
      $common_package_name         = 'freshdesk-common'
      $api_package_name            = 'freshdesk-api'
      $worker_package_name         = 'freshdesk-worker'
      $freshdesk_wsgi_script_path    = '/usr/lib/cgi-bin/freshdesk'
      $freshdesk_wsgi_script_source  = '/usr/share/freshdesk/freshdesk.wsgi'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
