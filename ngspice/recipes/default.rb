#
# Cookbook:: ngspice
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

current = 'ngspice-30' # ngspice-27

remote_file "/usr/local/src/#{current}.tar.gz" do
  source "https://sourceforge.net/projects/ngspice/files/ng-spice-rework/#{current.sub('ngspice-', '')}/#{current}.tar.gz"
  mode '0755'
end

bash 'extract ngspice' do
  cwd '/usr/local/src'
  code <<-EOH
    tar xzf /usr/local/src/#{current}.tar.gz
  EOH
  not_if { ::File.exist? "/usr/local/src/#{current}" }
end

case node[:platform]
when 'ubuntu', 'debian'
  packages = ['gcc', 'bison', 'make', 'libxaw7-dev']
when 'centos'
  packages = ['libXaw-devel', 'gcc', 'make']
end

link '/bin/env' do
  owner 'root'
  to '/usr/bin/env'
end unless File.exist? '/bin/env'

packages.each{|p|
  package p do
    action :install
  end
}

bash 'build ngspice' do
  install_path = '/usr/local/bin/ngspice'
  cwd "/usr/local/src/#{current}"
  code <<-EOF
    ./configure --enable-xspice
    make && make install
  EOF
  not_if { ::File.exist? install_path }
end
