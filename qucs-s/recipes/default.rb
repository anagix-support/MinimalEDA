#
# Cookbook:: qucs-s
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

bash 'install qucs-s' do
  install_path = '/usr/bin/qucs-s'
  update_sources_list_command = `grep ra3xdh /etc/apt/sources.list` == '' ? "echo 'deb http://download.opensuse.org/repositories/home:/ra3xdh/Debian_9.0/ ./' >> /etc/apt/sources.list" : ''
  code <<-EOH
    wget -c http://download.opensuse.org/repositories/home:/ra3xdh/Debian_9.0/Release.key
    #{update_sources_list_command}
    apt-key add Release.key
    apt-get update
    apt-get install -y --allow-unauthenticated qucs-s
  EOH
  not_if { ::File.exist? install_path }
end
