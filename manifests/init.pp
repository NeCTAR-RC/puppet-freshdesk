# ::freshdesk
#
# === Parameters
# [*local_mongo*] Install mongodb-server with default settings. Defaults to true.
#
class freshdesk (
  $local_mongo = true,

) {

  include ::freshdesk::apache
  include ::freshdesk::osid
  include ::freshdesk::pip

  if $local_mongo {
    ensure_packages('mongodb-server')
  }
}
