# ::freshdesk
#
class freshdesk {

  include ::freshdesk::apache
  include ::freshdesk::osid
  include ::freshdesk::pip

}
