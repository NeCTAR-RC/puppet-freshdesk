# == Class: freshdesk::deps
#
#  freshdesk anchors and dependency management
#
class freshdesk::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'freshdesk::install::begin': }
  -> Package<| tag == 'freshdesk-package'|>
  ~> anchor { 'freshdesk::install::end': }
  -> anchor { 'freshdesk::config::begin': }
  -> Freshdesk_config<||>
  ~> anchor { 'freshdesk::config::end': }
  ~> anchor { 'freshdesk::service::begin': }
  ~> Service<| tag == 'freshdesk-service' |>
  ~> anchor { 'freshdesk::service::end': }

  # Installation or config changes will always restart services.
  Anchor['freshdesk::install::end'] ~> Anchor['freshdesk::service::begin']
  Anchor['freshdesk::config::end']  ~> Anchor['freshdesk::service::begin']

}
