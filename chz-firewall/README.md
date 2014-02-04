Description
===========
Firewall cookbook for Windows and GNU/Linux applications, developed at Cheezburger Inc.

License
=======
New BSD License

Requirements
============
Windows, Ubuntu, or RHEL based

Attributes
==========
['chz-firewall']['version']		Integer, if changed firewall will reload on windows. 
					Linux firewall is dynamic with attribute changes
['chz-firewall']['whitelist']		Array of IPs to whitelist
['chz-firewall']['blacklist']		Array of IPs to blacklist
['chz-firewall']['enable_ping']		Boolean, to allow incoming ping
['chz-firewall']['tcp_in']		Array of ports to open
['chz-firewall']['tcp_out']		Same
['chz-firewall']['udp_in'] 		Same
['chz-firewall']['udp_out']		Same
['chz-firewall']['firewall_type']	Iptables or windows autodetected, csf (http://configserver.com/cp/csf.html) partial support
['chz-firewall']['whitelist_interfaces'] = [ "lo" ]
['chz-firewall']['enable_vrrp']         Boolean, to enable vrrp (for keepalived to work)
['chz-firewall']['default_deny_in']     Boolean, drops unmatched traffic in if true
['chz-firewall']['default_deny_out']    Boolean, drops unmatched traffic out if true
['chz-firewall']['allow_established']   Boolean, allows established connections if true


Usage
=====
Use default recipe for default rules with iptables or windows firewall.
Use attribute overrides to change settings.
Create databag 'chz-firewall' to optionally store whitelist and blacklist ip addresses with metadata. Example below:

   {
       "id": "office_ip_1",
       "type": "whitelist",
       "ip": "1.2.3.4",
       "desc": "Generic ISP office IP"
   }

Use type blacklist to create a blacklist item.


Notes
=====
Not all attributes are yet supported by all types of firewalls. Vrrp and interface whitelist do not work in windows.
Tested on Ubuntu 12.04, Windows 2012 and 2008r2.
