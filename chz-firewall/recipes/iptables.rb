whitelist_dbag = search(:'chz-firewall', "type:whitelist") rescue []
blacklist_dbag = search(:'chz-firewall', "type:blacklist") rescue []

whitelist = []
blacklist = []

whitelist = whitelist_dbag.map { |a| a['ip'] }
blacklist = blacklist_dbag.map { |a| a['ip'] }

whitelist = whitelist.concat(node['chz-firewall']['whitelist'])
blacklist = blacklist.concat(node['chz-firewall']['blacklist'])

if (FileTest.directory?("/etc/csf"))
  execute "Disable CSF" do
    command "csf -x"
  end
end

case node['platform']
when  "ubuntu", "debian"
  execute "Disable UFW" do
    command "ufw disable"
  end
  template "/etc/network/if-pre-up.d/iptablesload" do
    source "iptablesload.erb"
    mode 0555
    owner "root"
    group "root"
  end
end

template "#{node['chz-firewall']['iptables']['savefile']}" do
  source "iptables.save.erb"
  mode 0444
  owner "root"
  group "root"
  variables({
    :whitelist => whitelist,
    :blacklist => blacklist
  })
  notifies :run, "execute[iptables-restore]", :immediate
end

execute "iptables-restore" do
  command "iptables-restore < #{node['chz-firewall']['iptables']['savefile']}"
end

case node['platform']
when "redhat", "centos", "fedora"
  service "iptables" do
    action :enable
    supports :status => true, :start => true, :stop => true, :restart => true, :save => true
    subscribes :save, resources("template[#{node['chz-firewall']['iptables']['savefile']}]"), :delayed
  end
end

