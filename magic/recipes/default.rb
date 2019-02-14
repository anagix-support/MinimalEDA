#
# Cookbook:: magic
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

current = 'magic-8.1.224'
remote_file "/usr/local/src/#{current}.tgz" do
  source "http://opencircuitdesign.com/magic/archive/#{current}.tgz"
  mode '0755'
end

bash 'extract magic' do
  cwd '/usr/local/src'
  code <<-EOH
    tar xzf /usr/local/src/#{current}.tgz
  EOH
  not_if { ::File.exist? "/usr/local/src/#{current}" }
end

case node[:platform]
when 'ubuntu', 'debian'
  packages = ['csh', 'tk-dev', 'tcl-dev', 'm4']
when 'centos'
  packages = ['csh', 'tk-devel', 'tcl-devel', 'm4', 'gcc', 'make']
end

packages.each{|p|
  package p do
    action :install
  end
}

bash 'build magic' do
  install_path = '/usr/local/bin/magic'
  cwd "/usr/local/src/#{current}"
  code <<-EOF
    ./configure
    make && make install
  EOF
  not_if { ::File.exist? install_path }
end
  
