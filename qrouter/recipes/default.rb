#
# Cookbook:: qrouter
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
include_recipe 'magic'

remote_file '/usr/local/src/qrouter-1.3.91.tgz' do
  source 'http://opencircuitdesign.com/qrouter/archive/qrouter-1.3.91.tgz'
  mode '0755'
end

bash 'extract qrouter' do
  cwd '/usr/local/src'
  code <<-EOH
    tar xzf /usr/local/src/qrouter-1.3.91.tgz
  EOH
  not_if { ::File.exist? '/usr/local/src/qrouter-1.3.91' }
end

case node[:platform]
when 'ubuntu'
  packages = ['tk-dev']
when 'centos'
  packages = ['tk-devel', 'libXt-devel']
end

packages.each{|p|
  package p do
    action :install
  end
}

bash 'build qrouter' do
  install_path = '/usr/local/bin/qrouter'
  cwd '/usr/local/src/qrouter-1.3.91'
  code <<-EOF
    ./configure
    make && make install
  EOF
  not_if { ::File.exist? install_path }
end
  
