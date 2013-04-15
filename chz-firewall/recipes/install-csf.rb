
chkconfig = "update-rc.d"
chkconfig_suffix = "defaults"

case node['platform']
when  "redhat", "centos", "scientific", "amazon", "fedora"
  chkconfig = "chkconfig"
  chkconfig_suffix = "on"
end

package "libwww-perl" do
  action :install
end

execute "Download CSF" do
  cwd "/tmp/"
  command <<-EOH
  wget http://configserver.com/free/csf.tgz
  tar -vzxf csf.tgz
  EOH
  creates "/tmp/csf.tgz"
end

execute "Install CSF" do
  cwd "/tmp/csf/"
  command "sh install.sh"
  returns [0,127]
  creates "/etc/csf/csf.conf"
end
