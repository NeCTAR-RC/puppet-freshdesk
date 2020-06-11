#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == Class: freshdesk::apache
#
# Install freshdesk API under apache with mod_wsgi.
#
# == Parameters:
#
# [*servername*]
#   (Optional) The servername for the virtualhost.
#   Defaults to $::fqdn
#
# [*serveraliases*]
#   (Optional) Any server aliases
#   Defaults to []
#
# [*port*]
#   (Optional) The port.
#   Defaults to 80
#
# [*bind_host*]
#   (Optional) The host/ip address Apache will listen on.
#   Defaults to undef (listen on all ip addresses).
#
# [*path*]
#   (Optional) The prefix for the endpoint.
#   Defaults to '/'
#
# [*ssl*]
#   (Optional) Use ssl.
#   Defaults to false
#
# [*workers*]
#   (Optional) Number of WSGI workers to spawn.
#   Defaults to $::os_workers
#
# [*priority*]
#   (Optional) The priority for the vhost.
#   Defaults to '10'
#
# [*threads*]
#   (Optional) The number of threads for the vhost.
#   Defaults to 1
#
# [*wsgi_process_display_name*]
#   (Optional) Name of the WSGI process display-name.
#   Defaults to undef
#
# [*ssl_cert*]
# [*ssl_key*]
# [*ssl_chain*]
# [*ssl_ca*]
# [*ssl_crl_path*]
# [*ssl_crl*]
# [*ssl_certs_dir*]
#   (Optional) apache::vhost ssl parameters.
#   Default to apache::vhost 'ssl_*' defaults
#
# [*access_log_file*]
#   (Optional) The log file name for the virtualhost.
#   Defaults to false
#
# [*access_log_format*]
#   (Optional) The log format for the virtualhost.
#   Defaults to false
#
# [*error_log_file*]
#   (Optional) The error log file name for the virtualhost.
#   Defaults to undef
#
# [*custom_wsgi_process_options*]
#   (Optional) gives you the opportunity to add custom process options or to
#   overwrite the default options for the WSGI main process.
#   eg. to use a virtual python environment for the WSGI process
#   you could set it to:
#   { python-path => '/my/python/virtualenv' }
#   Defaults to {}
#
# == Example:
#
#   include apache
#   class { 'freshdesk::apache': }
#
class freshdesk::apache (
  $servername                  = $::fqdn,
  $serveraliases               = [],
  $bind_host                   = '*',
  $port                        = 80,
  $path                        = '/',
  $priority                    = '10',
  $ssl                         = false,
  $ssl_cert                    = undef,
  $ssl_key                     = undef,
  $ssl_chain                   = undef,
  $ssl_ca                      = undef,
  $ssl_crl_path                = undef,
  $ssl_crl                     = undef,
  $ssl_certs_dir               = undef,
  $user                        = $::freshdesk::user,
  $group                       = $::freshdesk::group,
  $workers                     = $::os_workers,
  $venv_dir                    = $::freshdesk::venv_dir,
  $wsgi_daemon_process         = 'freshdesk',
  $wsgi_process_display_name   = 'freshdesk',
  $wsgi_process_group          = 'freshdesk',
  $wsgi_script_dir             = $::freshdesk::app_dir,
  $wsgi_script_file            = 'wsgi.py',
  $wsgi_script_source          = undef,
  $wsgi_application_group      = '%{GLOBAL}',
  $wsgi_pass_authorization     = undef,
  $wsgi_chunked_request        = undef,
  $threads                     = 1,
  $access_log_file             = false,
  $access_log_pipe             = false,
  $access_log_syslog           = false,
  $access_log_format           = false,
  $error_log_file              = undef,
  $error_log_pipe              = undef,
  $error_log_syslog            = undef,
) {

  include ::freshdesk
  include ::freshdesk::deps

  include ::apache
  include ::apache::mod::wsgi

  if $ssl {
    include ::apache::mod::ssl
  }

  # Ensure there's no trailing '/' except if this is also the only character
  $path_real = regsubst($path, '(^/.*)/$', '\1')
  $wsgi_script_alias = hash([$path_real,"${wsgi_script_dir}/${wsgi_script_file}"])

  ::apache::vhost { 'freshdesk':
    ensure                      => 'present',
    servername                  => $servername,
    serveraliases               => $serveraliases,
    ip                          => $bind_host,
    port                        => $port,
    docroot                     => $wsgi_script_dir,
    docroot_owner               => $user,
    docroot_group               => $group,
    priority                    => $priority,
    setenvif                    => ['X-Forwarded-Proto https HTTPS=1'],
    ssl                         => $ssl,
    ssl_cert                    => $ssl_cert,
    ssl_key                     => $ssl_key,
    ssl_chain                   => $ssl_chain,
    ssl_ca                      => $ssl_ca,
    ssl_crl_path                => $ssl_crl_path,
    ssl_crl                     => $ssl_crl,
    ssl_certs_dir               => $ssl_certs_dir,
    wsgi_daemon_process         => $wsgi_daemon_process,
    wsgi_daemon_process_options => {
        user         => $user,
        group        => $group,
        processes    => $workers,
        threads      => $threads,
        display-name => $wsgi_process_display_name,
        python-home  => $venv_dir,
    },
    wsgi_process_group          => $wsgi_process_group,
    wsgi_script_aliases         => $wsgi_script_alias,
    wsgi_application_group      => $wsgi_application_group,
    wsgi_pass_authorization     => $wsgi_pass_authorization,
    wsgi_chunked_request        => $wsgi_chunked_request,
    access_log_file             => $access_log_file,
    access_log_pipe             => $access_log_pipe,
    access_log_syslog           => $access_log_syslog,
    access_log_format           => $access_log_format,
    error_log_file              => $error_log_file,
    error_log_pipe              => $error_log_pipe,
    error_log_syslog            => $error_log_syslog,
    options                     => ['-Indexes', '+FollowSymLinks','+MultiViews'],
    require                     => Python::Pip['nectar-freshdesk'],
  }
}
