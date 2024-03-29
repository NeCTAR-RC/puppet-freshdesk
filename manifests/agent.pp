# Configure the freshdesk controller agent service
#
# == Parameters
#
# [*enabled*]
#   (optional) Should the service be enabled.
#   Defaults to true
#
# [*manage_service*]
#   (optional) Whether the service should be managed by Puppet.
#   Defaults to true.
#
class freshdesk::agent (
  $manage_service         = true,
  $enabled                = true,
) {

  include ::freshdesk
  include ::freshdesk::deps
  include ::systemd

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  $user     = $::freshdesk::user
  $group    = $::freshdesk::group
  $base_dir = $::freshdesk::base_dir
  $venv_dir = $::freshdesk::venv_dir

  file { '/etc/systemd/system/freshdesk-openstack-agent.service':
    ensure  => present,
    content => template('freshdesk/freshdesk-openstack-agent.service.erb'),
    require => Python::Pip['nectar-freshdesk'],
  }

  service { 'freshdesk-openstack-agent':
    ensure     => $service_ensure,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => ['freshdesk-openstack-service'],
    require    => File['/etc/systemd/system/freshdesk-openstack-agent.service'],
  }

}
