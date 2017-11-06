#
# Cookbook:: netgen
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.



remote_file '/usr/local/src/netgen-1.4.81.tgz' do
  source 'http://opencircuitdesign.com/netgen/archive/netgen-1.4.81.tgz'
  mode '0755'
end

bash 'extract netgen' do
  cwd '/usr/local/src'
  code <<-EOH
    tar xzf /usr/local/src/netgen-1.4.81.tgz
  EOH
  not_if { ::File.exist? '/usr/local/src/netgen-1.4.81' }
end

packages = ['tk-dev', 'tcl-dev']
packages.each{|p|
  package p do
    action :install
  end
}

bash 'build netgen' do
  install_path = '/usr/local/bin/netgen'
  cwd '/usr/local/src/netgen-1.4.81'
  code <<-EOF
    ./configure
    make && make install
  EOF
  not_if { ::File.exist? install_path }
end
  
