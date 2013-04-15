package "libssl0.9.8" do
  action :install
end

execute "Download couchbase" do
  command "wget #{node['couchbase']['url']}"
  cwd "/usr/local/src/"
  creates "/usr/local/src/#{node['couchbase']['install_file']}"
end

execute "Install couchbase" do
  command "dpkg -i #{node['couchbase']['install_file']} > /usr/local/src/couchbase.log"
  cwd "/usr/local/src/"
  creates "/usr/local/src/couchbase.log"
end

execute 'start couchbase' do
    command '/etc/init.d/couchbase-server start'
    returns [0,2]
end
