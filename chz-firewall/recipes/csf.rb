include_recipe "chz-firewall::install-csf"

service "csf" do
  supports :restart => true, :start => true, :stop => true, :reload => true
  action :nothing
end

template "/etc/csf/csf.conf" do
  source "csf.conf.erb"
  mode 0444
  owner "root"
  group "root"
  notifies :restart, resources(:service => "csf"), :immediate
end

template "/etc/csf/csf.allow" do
  source "csf.allow.erb"
  mode 0444
  owner "root"
  group "root"
  notifies :restart, resources(:service => "csf"), :immediate
end

template "/etc/csf/csf.ignore" do
  source "csf.ignore.erb"
  mode 0444
  owner "root"
  group "root"
  notifies :restart, resources(:service => "csf"), :immediate
end

template "/etc/csf/csf.deny" do
  source "csf.deny.erb"
  mode 0444
  owner "root"
  group "root"
  notifies :restart, resources(:service => "csf"), :immediate
end


execute 'start csf' do
    command 'csf -e'
    returns [0,2]
end
