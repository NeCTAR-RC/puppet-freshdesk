# == Class: freshdesk::config
#
# This class is used to manage arbitrary freshdesk configurations.
#
# === Parameters
#
# [*freshdesk_config*]
#   (optional) Allow configuration of arbitrary freshdesk configurations.
#   The value is an hash of freshdesk_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   freshdesk_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class freshdesk::config (
  $freshdesk_config = {},
) {

  include ::freshdesk::deps

  validate_legacy(Hash, 'validate_hash', $freshdesk_config)

  create_resources('freshdesk_config', $freshdesk_config)
}
