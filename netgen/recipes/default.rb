#
# Cookbook:: netgen
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

current = 'netgen-1.5.118' # netgen-1.5.89

remote_file "/usr/local/src/#{current}.tgz" do
  source "http://opencircuitdesign.com/netgen/archive/#{current}.tgz"
  mode '0755'
end

bash 'extract netgen' do
  cwd '/usr/local/src'
  code <<-EOH
    tar xzf /usr/local/src/#{current}.tgz
  EOH
  not_if { ::File.exist? "/usr/local/src/#{current}" }
end

case node[:platform]
when 'ubuntu', 'debian'
  packages = ['tk-dev', 'tcl-dev', 'm4']
when 'centos'
  packages = ['tk-devel', 'tcl-devel', 'm4', 'gcc', 'make']
end

packages.each{|p|
  package p do
    action :install
  end
}

bash 'build netgen' do
  install_path = '/usr/local/bin/netgen'
  cwd "/usr/local/src/#{current}"
  code <<-EOF
    ./configure
    make && make install
    sed -i -e 's:#\!/bin/sh:#\!/bin/bash:' #{install_path}
  EOF
  not_if { ::File.exist? install_path }
end
  
