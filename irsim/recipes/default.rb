#
# Cookbook:: irsim
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

current = 'irsim-9.7.101' # irsim-9.7.98

remote_file "/usr/local/src/#{current}.tgz" do
  source "http://opencircuitdesign.com/irsim/archive/#{current}.tgz"
  mode '0755'
end

bash 'extract irsim' do
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
  packages = ['tcl-devel', 'tk-devel', 'm4', 'gcc', 'make']
end

packages.each{|p|
  package p do
    action :install
  end
}

bash 'build irsim' do
  install_path = '/usr/local/bin/irsim'
  cwd "/usr/local/src/#{current}"
  code <<-EOF
    ./configure
    make && make install
  EOF
  not_if { ::File.exist? install_path }
end
  
