#
# Cookbook:: qrouter
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
include_recipe 'magic'

current = 'qrouter-1.4.59'
remote_file "/usr/local/src/#{current}.tgz" do
  source "http://opencircuitdesign.com/qrouter/archive/#{current}.tgz"
  mode '0755'
end

bash 'extract qrouter' do
  cwd '/usr/local/src'
  code <<-EOH
    tar xzf /usr/local/src/#{current}.tgz
  EOH
  not_if { ::File.exist? "/usr/local/src/#{current}" }
end

case node[:platform]
when 'ubuntu', 'debian'
  packages = ['tk-dev', 'make']
when 'centos'
  packages = ['tk-devel', 'libXt-devel', 'make']
end

packages.each{|p|
  package p do
    action :install
  end
}

bash 'build qrouter' do
  install_path = '/usr/local/bin/qrouter'
  cwd "/usr/local/src/#{current}"
  code <<-EOF
    ./configure
    make && make install
  EOF
  not_if { ::File.exist? install_path }
end
  
