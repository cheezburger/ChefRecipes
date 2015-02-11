default['chz-firewall']['version']		= "6"
default['chz-firewall']['whitelist']		= [ ]
default['chz-firewall']['blacklist']  		= [ ]
default['chz-firewall']['whitelist_interfaces']	= [ "lo" ]
default['chz-firewall']['enable_ping']		= true
default['chz-firewall']['enable_vrrp']		= false
default['chz-firewall']['default_deny_in']	= true
default['chz-firewall']['default_deny_out']	= false
default['chz-firewall']['allow_established']	= true
default['chz-firewall']['iptables']['savefile']	= "/etc/chz-iptables.save"


case node['platform_family']
when "debian","rhel","fedora","suse"
  default['chz-firewall']['firewall_type'] 	= "iptables"
  default['chz-firewall']['tcp_in']           	= [ ]
  default['chz-firewall']['tcp_out']            = [ 20,21,22,25,53,80,110,113,443,4740 ]
  default['chz-firewall']['udp_in']          	= [ ]
  default['chz-firewall']['udp_out']            = [ 20,21,53,113,123 ]
when "windows"
  default['chz-firewall']['firewall_type']      = "windows"
  default['chz-firewall']['tcp_in']             = [ ]
  default['chz-firewall']['tcp_out']            = [ ]
  default['chz-firewall']['udp_in']             = [ ]
  default['chz-firewall']['udp_out']            = [ ]
end 
