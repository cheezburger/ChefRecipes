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

execute "iptables-restore" do
  command "iptables-restore < #{node['chz-firewall']['iptables']['savefile']}"
  action :nothing
end

template "#{node['chz-firewall']['iptables']['savefile']}" do
  source "iptables.save.erb"
  mode 0444
  owner "root"
  group "root"
  notifies :run, "execute[iptables-restore]", :immediate
end

case node['platform']
when "redhat", "centos", "fedora"
  service "iptables" do
    action :enable
    supports :status => true, :start => true, :stop => true, :restart => true, :save => true
    subscribes :save, resources("template[#{node['chz-firewall']['iptables']['savefile']}]"), :delayed
  end
end

