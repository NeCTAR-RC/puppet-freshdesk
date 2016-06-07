# freshdesk::apache
#
# Sets up apache to proxy ssl connections.
#
# === Parameters
# [*servername*] vhost name, defaults to fqdn
#
# [*port*] port that that apache will listen on
#
# [*bind_host*] IP address to listen on, Defaults to undef, which binds to
# all addresses.
#
# [*ssl*] whether to enable ssl.
#
# [*ssl_cert*] path to ssl cert Defaults to $ssl_cert_path provided by the
# nectar_ssl module
#
# [*ssl_key*] path to ssl key. Defaults to $ssl_key_path provided by the
# nectar_ssl module
#
# [*ssl_chain*] path to file containing full ssl chain. Full chain can also
# be specified in ssl_cert. Defaults to undef
#
# [*ssl_ca*] path to ca certificate Defaults to undef
#
# [*ssl_certs_dir*] path where all ssl certs live. Defaults to undef.
#

class freshdesk::apache (

  $server_name   = $::fqdn,
  $port          = 443,
  $bind_host     = undef,
  $service_name  = 'freshdesk',
  $ssl           = true,
  $ssl_cert      = $::ssl_cert_path,
  $ssl_key       = $::ssl_key_path,
  $ssl_chain     = undef,
  $ssl_ca        = undef,
  $ssl_certs_dir = undef,

  ) {

  include ::freshdesk::osid
  include ::freshdesk::pip

  include ::apache
  if $ssl {
    include ::apache::mod::ssl
    File <| tag == 'sslcert' |> {
      notify +> Service[$::apache::service::service_name],
    }
  }
  include ::apache::mod::proxy
  include ::apache::mod::proxy_http

  ::apache::vhost { $service_name:
    ensure        => 'present',
    servername    => $servername,
    ip            => $bind_host,
    port          => $port,
    docroot       => '/var/www/html',
    proxy_pass    => [
    {
      'path' => '/osid',
      'url'  => "http://localhost:${::freshdesk::osid::port}/osid",
    },
    {
      'path' => '/pip',
      'url'  => "http://localhost:${::freshdesk::pip::port}/pip",
    },
    ],
    ssl           => $ssl,
    ssl_cert      => $ssl_cert,
    ssl_key       => $ssl_key,
    ssl_chain     => $ssl_chain,
    ssl_ca        => $ssl_ca,
    ssl_certs_dir => $ssl_certs_dir,
  }
}
