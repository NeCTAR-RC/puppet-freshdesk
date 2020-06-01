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
) inherits freshdesk::params {

  include ::freshdesk::deps
  include ::systemd

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  file { '/etc/systemd/system/freshdesk-openstack-agent.service':
    ensure  => present,
    content => template('freshdesk/freshdesk-openstack-agent.service.erb'),
    notify  => Exec['systemctl-daemon-reload']
  }

  service { 'freshdesk-openstack-agent':
    ensure     => $service_ensure,
    name       => $::freshdesk::params::agent_service_name,
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    tag        => ['freshdesk-openstack-service'],
  }

}
