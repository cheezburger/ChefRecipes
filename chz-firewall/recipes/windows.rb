execute "windows-nuke-rules" do
  command "netsh advfirewall firewall delete rule name=all > c:/chz-fw-#{node['chz-firewall']['version']}.txt"
  creates "c:/chz-fw-#{node['chz-firewall']['version']}.txt"
end

#Translate attributes to windows firewall states
if node['chz-firewall']['default_deny_in']
  policy_in = "blockinbound"
else
  policy_in = "allowinbound"
end
if  node['chz-firewall']['default_deny_out']
  policy_out = "blockoutbound"
else
  policy_out = "allowoutbound"
end

execute "default block inbound" do
  command "netsh advfirewall set allprofiles firewallpolicy #{policy_in},#{policy_out}"
end

node['chz-firewall']['whitelist'].each do |host|
  powershell "windows-whitelist-#{host}" do
    code <<-EOH
      $hostip = "#{host}"
      $name = "IP $hostip whitelist"
      $x = netsh advfirewall firewall show rule name="$name"
      if ($LastExitCode -ne 0) {
         Write-Host "Opening $name"
         netsh advfirewall firewall add rule name="$name" dir=in action=allow protocol=any remoteip="$hostip"
      } 
      else {
         Write-Host "$name is already added"
      }
    EOH
  end
end

node['chz-firewall']['blacklist'].each do |host|
  powershell "windows-blacklist-#{host}" do
    code <<-EOH
      $hostip = "#{host}"
      $name = "IP $hostip blacklist"
      $x = netsh advfirewall firewall show rule name="$name"
      if ($LastExitCode -ne 0) {
         Write-Host "Closing $name"
         netsh advfirewall firewall add rule name="$name" dir=in action=block protocol=any remoteip="$hostip"
      }
      else {
         Write-Host "$name is already added"
      }
    EOH
  end
end

if node['chz-firewall']['tcp_in'].any?
  node['chz-firewall']['tcp_in'].each do |port|
    powershell "open-tcp-in" do
      code <<-EOH
        $tcpPort = "#{port}"
        $name = "Port $tcpPort inbound"
        $x = netsh advfirewall firewall show rule name="$name"
        if ($LastExitCode -ne 0) {
          Write-Host "Opening $name"
          netsh advfirewall firewall add rule name="$name" dir=in action=allow protocol=TCP localport=$tcpPort
        } else {
          Write-Host "$name is already open"
        }
      EOH
    end
  end
end

if node['chz-firewall']['tcp_out'].any?
  node['chz-firewall']['tcp_out'].each do |port|
    powershell "open-tcp-out" do
      code <<-EOH
        $tcpPort = "#{port}"
        $name = "Port $tcpPort outbound"
        $x = netsh advfirewall firewall show rule name="$name"
        if ($LastExitCode -ne 0) {
          Write-Host "Opening $name"
          netsh advfirewall firewall add rule name="$name" dir=out action=allow protocol=TCP localport=$tcpPort
        } else {
          Write-Host "$name is already open"
        }
      EOH
    end
  end
end

if node['chz-firewall']['udp_in'].any?
  node['chz-firewall']['udp_in'].each do |port|
    powershell "open-udp-in" do
      code <<-EOH
        $udpPort = "#{port}"
        $name = "Port $udpPort inbound"
        $x = netsh advfirewall firewall show rule name="$name"
        if ($LastExitCode -ne 0) {
          Write-Host "Opening $name"
          netsh advfirewall firewall add rule name="$name" dir=in action=allow protocol=UDP localport=$udpPort
        } else {
          Write-Host "$name is already open"
        }
      EOH
    end
  end
end

if node['chz-firewall']['udp_out'].any?
  node['chz-firewall']['udp_out'].each do |port|
    powershell "open-udp-out" do
      code <<-EOH
        $udpPort = "#{port}"
        $name = "Port $udpPort outbound"
        $x = netsh advfirewall firewall show rule name="$name"
        if ($LastExitCode -ne 0) {
          Write-Host "Opening $name"
          netsh advfirewall firewall add rule name="$name" dir=out action=allow protocol=UDP localport=$udpPort
        } else {
          Write-Host "$name is already open"
        }
      EOH
    end
  end
end

if ( node['chz-firewall']['enable_ping'] )
  powershell "enable ping" do
    code <<-EOH
      $name = "ICMPv4 Inbound"
      $x = netsh advfirewall firewall show rule name="$name"
      if ($LastExitCode -ne 0) {
        Write-Host "Opening $name"
        netsh advfirewall firewall add rule name="$name" dir=in action=allow enable=yes profile=any localip=any remoteip=any protocol="icmpv4:8,any" interfacetype=any edge=yes
      } else {
        Write-Host "$name is already open"
      }
    EOH
  end
end
