#
# Cookbook:: irsim
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

remote_file '/usr/local/src/irsim-9.7.98.tgz' do
  source 'http://opencircuitdesign.com/irsim/archive/irsim-9.7.98.tgz'
  mode '0755'
end

bash 'extract irsim' do
  cwd '/usr/local/src'
  code <<-EOH
    tar xzf /usr/local/src/irsim-9.7.98.tgz
  EOH
  not_if { ::File.exist? '/usr/local/src/irsim-9.7.98' }
end

packages = []
packages.each{|p|
  package p do
    action :install
  end
}

bash 'build irsim' do
  install_path = '/usr/local/bin/irsim'
  cwd '/usr/local/src/irsim-9.7.98'
  code <<-EOF
    ./configure
    make && make install
  EOF
  not_if { ::File.exist? install_path }
end
  
