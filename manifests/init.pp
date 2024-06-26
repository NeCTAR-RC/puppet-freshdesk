# == Class: freshdesk
#
# Full description of class freshdesk here.
#
# === Parameters
#
# [*freshdesk_api_key*]
#   (required) The API key used for interacting with the Freshdesk API
#
# [*freshdesk_sso_secret*]
#   (optional) The Freshdesk SSO secret for Simple SSO
#
# [*freshdesk_sso_private_key*]
#   (optional) The Freshdesk SSO private key for JWT auth
#
# [*freshdesk_domain*]
#   (optional) The Freshdesk domain to work with
#   Defaults to dhdnectar.freshdesk.com
#
# [*freshdesk_sso_url*]
#   (required) The SSO URL for the Freshdesk domain
#
# [*auth_service_url*]
#   (required) The URL endpoint of this service, with the method.
#   Defaults to 'https://$::fqdn'
#
# [*auth_login_url*]
#   (required) The AAF RapidConnect URL for this service
#
# [*auth_secret*]
#   (required) The AAF RapidConnect secret key for this service
#
# [*flask_secret_key*]
#   (optional) A secret token used for Flask sessions
#
# [*package_ensure*]
#   (optional) The state of freshdesk packages
#   Defaults to 'present'
#
# [*default_transport_url*]
#  (optional) A URL representing the messaging driver to use and its full
#  configuration. Transport URLs take the form:
#    transport://user:pass@host1:port[,hostN:portN]/virtual_host
#  Defaults to $::os_service_default
#
# [*rpc_response_timeout*]
#  (Optional) Seconds to wait for a response from a call.
#  Defaults to $::os_service_default
#
# [*control_exchange*]
#   (Optional) The default exchange under which topics are scoped. May be
#   overridden by an exchange name specified in the transport_url
#   option.
#   Defaults to $::os_service_default
#
# [*rabbit_use_ssl*]
#   (optional) Connect over SSL for RabbitMQ
#   Defaults to $::os_service_default
#
# [*rabbit_ha_queues*]
#   (optional) Use HA queues in RabbitMQ.
#   Defaults to $::os_service_default
#
# [*rabbit_heartbeat_timeout_threshold*]
#   (optional) Number of seconds after which the RabbitMQ broker is considered
#   down if the heartbeat keepalive fails.  Any value >0 enables heartbeats.
#   Heartbeating helps to ensure the TCP connection to RabbitMQ isn't silently
#   closed, resulting in missed or lost messages from the queue.
#   (Requires kombu >= 3.0.7 and amqp >= 1.4.0)
#   Defaults to $::os_service_default
#
# [*rabbit_heartbeat_rate*]
#   (optional) How often during the rabbit_heartbeat_timeout_threshold period to
#   check the heartbeat on RabbitMQ connection.  (i.e. rabbit_heartbeat_rate=2
#   when rabbit_heartbeat_timeout_threshold=60, the heartbeat will be checked
#   every 30 seconds.
#   Defaults to $::os_service_default
#
# [*kombu_ssl_ca_certs*]
#   (optional) SSL certification authority file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_certfile*]
#   (optional) SSL cert file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_keyfile*]
#   (optional) SSL key file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_version*]
#   (optional) SSL version to use (valid only if SSL enabled).
#   Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be
#   available on some distributions.
#   Defaults to $::os_service_default
#
# [*kombu_reconnect_delay*]
#   (optional) How long to wait before reconnecting in response to an AMQP
#   consumer cancel notification.
#   Defaults to '$::os_service_default
#
# [*kombu_failover_strategy*]
#   (Optional) Determines how the next RabbitMQ node is chosen in case the one
#   we are currently connected to becomes unavailable. Takes effect only if
#   more than one RabbitMQ node is provided in config. (string value)
#   Defaults to $::os_service_default
#
# [*kombu_compression*]
#   (optional) Possible values are: gzip, bz2. If not set compression will not
#   be used. This option may notbe available in future versions. EXPERIMENTAL.
#   (string value)
#   Defaults to $::os_service_default
#
# [*amqp_durable_queues*]
#   (optional) Define queues as "durable" to rabbitmq.
#   Defaults to $::os_service_default
#
# [*amqp_server_request_prefix*]
#   (Optional) Address prefix used when sending to a specific server
#   Defaults to $::os_service_default.
#
# [*amqp_broadcast_prefix*]
#   (Optional) address prefix used when broadcasting to all servers
#   Defaults to $::os_service_default.
#
# [*amqp_group_request_prefix*]
#   (Optional) address prefix when sending to any server in group
#   Defaults to $::os_service_default.
#
# [*amqp_container_name*]
#   (Optional) Name for the AMQP container
#   Defaults to $::os_service_default.
#
# [*amqp_idle_timeout*]
#   (Optional) Timeout for inactive connections
#   Defaults to $::os_service_default.
#
# [*amqp_trace*]
#   (Optional) Debug: dump AMQP frames to stdout
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_ca_file*]
#   (Optional) CA certificate PEM file to verify server certificate
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_cert_file*]
#   (Optional) Identifying certificate PEM file to present to clients
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_key_file*]
#   (Optional) Private key PEM file used to sign cert_file certificate
#   Defaults to $::os_service_default.
#
# [*amqp_ssl_key_password*]
#   (Optional) Password for decrypting ssl_key_file (if encrypted)
#   Defaults to $::os_service_default.
#
# [*amqp_sasl_mechanisms*]
#   (Optional) Space separated list of acceptable SASL mechanisms
#   Defaults to $::os_service_default.
#
# [*amqp_sasl_config_dir*]
#   (Optional) Path to directory that contains the SASL configuration
#   Defaults to $::os_service_default.
#
# [*amqp_sasl_config_name*]
#   (Optional) Name of configuration file (without .conf suffix)
#   Defaults to $::os_service_default.
#
# [*amqp_username*]
#   (Optional) User name for message broker authentication
#   Defaults to $::os_service_default.
#
# [*amqp_password*]
#   (Optional) Password for message broker authentication
#   Defaults to $::os_service_default.
#
# [*notification_transport_url*]
#   (optional) A URL representing the messaging driver to use for notifications
#   and its full configuration. Transport URLs take the form:
#     transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $::os_service_default
#
# [*notification_driver*]
#   (optional) Driver or drivers to handle sending notifications.
#   Value can be a string or a list.
#   Defaults to $::os_service_default
#
# [*notification_topics*]
#   (optional) AMQP topic used for OpenStack notifications
#   Defaults to $::os_service_default
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the freshdesk config.
#   Defaults to false.
#
class freshdesk (
  $freshdesk_api_key,
  $freshdesk_sso_url,
  $auth_service_url,
  $auth_login_url,
  $auth_secret,
  $freshdesk_sso_secret               = undef,
  $freshdesk_sso_private_key          = undef,
  $freshdesk_domain                   = 'dhdnectar.freshdesk.com',
  $user                               = 'freshdesk',
  $group                              = 'freshdesk',
  $base_dir                           = '/opt/nectar-freshdesk',
  $app_dir                            = "${base_dir}/app",
  $venv_dir                           = "${base_dir}/venv",
  $flask_secret_key                   = undef,
  $package_ensure                     = 'present',
  $default_transport_url              = $facts['os_service_default'],
  $rpc_response_timeout               = $facts['os_service_default'],
  $control_exchange                   = $facts['os_service_default'],
  $rabbit_use_ssl                     = $facts['os_service_default'],
  $rabbit_heartbeat_timeout_threshold = $facts['os_service_default'],
  $rabbit_heartbeat_rate              = $facts['os_service_default'],
  $rabbit_ha_queues                   = $facts['os_service_default'],
  $kombu_ssl_ca_certs                 = $facts['os_service_default'],
  $kombu_ssl_certfile                 = $facts['os_service_default'],
  $kombu_ssl_keyfile                  = $facts['os_service_default'],
  $kombu_ssl_version                  = $facts['os_service_default'],
  $kombu_reconnect_delay              = $facts['os_service_default'],
  $kombu_failover_strategy            = $facts['os_service_default'],
  $kombu_compression                  = $facts['os_service_default'],
  $amqp_durable_queues                = $facts['os_service_default'],
  $amqp_server_request_prefix         = $facts['os_service_default'],
  $amqp_broadcast_prefix              = $facts['os_service_default'],
  $amqp_group_request_prefix          = $facts['os_service_default'],
  $amqp_container_name                = $facts['os_service_default'],
  $amqp_idle_timeout                  = $facts['os_service_default'],
  $amqp_trace                         = $facts['os_service_default'],
  $amqp_ssl_ca_file                   = $facts['os_service_default'],
  $amqp_ssl_cert_file                 = $facts['os_service_default'],
  $amqp_ssl_key_file                  = $facts['os_service_default'],
  $amqp_ssl_key_password              = $facts['os_service_default'],
  $amqp_sasl_mechanisms               = $facts['os_service_default'],
  $amqp_sasl_config_dir               = $facts['os_service_default'],
  $amqp_sasl_config_name              = $facts['os_service_default'],
  $amqp_username                      = $facts['os_service_default'],
  $amqp_password                      = $facts['os_service_default'],
  $notification_transport_url         = $facts['os_service_default'],
  $notification_driver                = $facts['os_service_default'],
  $notification_topics                = $facts['os_service_default'],
  $purge_config                       = false,
) {

  include ::python

  include ::freshdesk::deps
  include ::freshdesk::service_auth
  include ::freshdesk::logging
  include ::freshdesk::agent
  include ::freshdesk::apache

  ensure_packages([ 'git', 'python3-flask', 'python3-freshdesk', 'python3-oslo.messaging',
                    'python3-oslo.config',  'python3-oslo.context','python3-oslo.middleware',
                    'python3-oslo.log', 'python3-jwt', 'python3-keystoneauth1',
                    'python3-keystoneclient', 'python3-novaclient', 'python3-glanceclient'])

  group { $group:
    ensure => present,
    system => true,
  }
  -> user { $user:
    system     => true,
    gid        => $group,
    home       => $base_dir,
    managehome => true,
  }
  -> file {['/etc/nectar-freshdesk',
            '/opt/nectar-freshdesk' ]:
    ensure => directory,
    owner  => $user,
  }
  -> python::virtualenv { $venv_dir:
    ensure     => present,
    version    => '3',
    systempkgs => true,
    distribute => false,
    owner      => $user,
  }
  -> vcsrepo { $app_dir:
    ensure   => present,
    provider => git,
    source   => 'https://github.com/NeCTAR-RC/nectar-freshdesk.git',
    branch   => 'master',
    user     => $user,
    require  => Package['git'],
  }
  -> python::pip { 'nectar-freshdesk':
    pkgname    => 'nectar-freshdesk',
    url        => $app_dir,
    virtualenv => $venv_dir,
    editable   => true,
    owner      => $user,
    tag        => ['nectar', 'freshdesk-package'],
    require    => Package['python3-flask'],
  }
  -> resources { 'freshdesk_config':
    purge => $purge_config,
  }

  # Set private key if given for JWT auth or use the Simple SSO secret
  if $freshdesk_sso_private_key {
    $freshdesk_sso_key = '/etc/nectar-freshdesk/private_key.pem'
    file { $freshdesk_sso_key:
      ensure  => present,
      owner   => 'root',
      group   => $group,
      mode    => '0440',
      content => $freshdesk_sso_private_key,
      require => File['/etc/nectar-freshdesk']
    }
  } else {
    $freshdesk_sso_key = $freshdesk_sso_secret
  }

  oslo::messaging::rabbit { 'freshdesk_config':
    rabbit_ha_queues            => $rabbit_ha_queues,
    heartbeat_timeout_threshold => $rabbit_heartbeat_timeout_threshold,
    heartbeat_rate              => $rabbit_heartbeat_rate,
    rabbit_use_ssl              => $rabbit_use_ssl,
    kombu_reconnect_delay       => $kombu_reconnect_delay,
    kombu_failover_strategy     => $kombu_failover_strategy,
    kombu_ssl_version           => $kombu_ssl_version,
    kombu_ssl_keyfile           => $kombu_ssl_keyfile,
    kombu_ssl_certfile          => $kombu_ssl_certfile,
    kombu_ssl_ca_certs          => $kombu_ssl_ca_certs,
    kombu_compression           => $kombu_compression,
    amqp_durable_queues         => $amqp_durable_queues,
  }

  oslo::messaging::amqp { 'freshdesk_config':
    server_request_prefix => $amqp_server_request_prefix,
    broadcast_prefix      => $amqp_broadcast_prefix,
    group_request_prefix  => $amqp_group_request_prefix,
    container_name        => $amqp_container_name,
    idle_timeout          => $amqp_idle_timeout,
    trace                 => $amqp_trace,
    ssl_ca_file           => $amqp_ssl_ca_file,
    ssl_cert_file         => $amqp_ssl_cert_file,
    ssl_key_file          => $amqp_ssl_key_file,
    ssl_key_password      => $amqp_ssl_key_password,
    sasl_mechanisms       => $amqp_sasl_mechanisms,
    sasl_config_dir       => $amqp_sasl_config_dir,
    sasl_config_name      => $amqp_sasl_config_name,
    username              => $amqp_username,
    password              => $amqp_password,
  }

  oslo::messaging::default { 'freshdesk_config':
    transport_url        => $default_transport_url,
    rpc_response_timeout => $rpc_response_timeout,
    control_exchange     => $control_exchange,
  }

  oslo::messaging::notifications { 'freshdesk_config':
    transport_url => $notification_transport_url,
    driver        => $notification_driver,
    topics        => $notification_topics,
  }

  freshdesk_config {
    'freshdesk/api_key':  value => $freshdesk_api_key;
    'freshdesk/domain':   value => $freshdesk_domain;
    'freshdesk/sso_url':  value => $freshdesk_sso_url;
    'freshdesk/sso_key':  value => $freshdesk_sso_key;
    'auth/service_url':   value => $auth_service_url;
    'auth/aaf_login_url': value => $auth_login_url;
    'auth/aaf_secret':    value => $auth_secret;
    'flask/secret_key':   value => $flask_secret_key;
  }
}
