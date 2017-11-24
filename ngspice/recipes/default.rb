#
# Cookbook:: ngspice
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

remote_file '/usr/local/src/ngspice-27.tar.gz' do
  source 'https://sourceforge.net/projects/ngspice/files/ng-spice-rework/27/ngspice-27.tar.gz'
  mode '0755'
end

bash 'extract ngspice' do
  cwd '/usr/local/src'
  code <<-EOH
    tar xzf /usr/local/src/ngspice-27.tar.gz
  EOH
  not_if { ::File.exist? '/usr/local/src/ngspice-27' }
end

case node[:platform]
when 'ubuntu', 'debian'
  packages = ['gcc', 'bison', 'make', 'libxaw7-dev']
when 'centos'
  packages = ['libXaw-devel', 'gcc', 'make']
end

packages.each{|p|
  package p do
    action :install
  end
}

bash 'build ngspice' do
  install_path = '/usr/local/bin/ngspice'
  cwd '/usr/local/src/ngspice-27'
  code <<-EOF
    ./configure --enable-xspice
    make && make install
  EOF
  not_if { ::File.exist? install_path }
end
