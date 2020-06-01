Puppet::Type.type(:freshdesk_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:openstack_config).provider(:ini_setting)
) do

  def self.file_path
    '/etc/nectar-freshdesk/nectar-freshdesk.conf'
  end

end
