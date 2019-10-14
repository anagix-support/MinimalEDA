#
# Cookbook:: klayout
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

current = 'klayout-0.2.6'

git '/usr/local/src/klayout' do
  repository 'https://github.com/KLayout/klayout.git'
  revision 'master'
  action :sync
end

case node[:platform]
when 'ubuntu', 'debian'
  packages = ['gcc', 'g++', 'make', 'libqt4-dev-bin', 'libqt4-dev', 'python3', 'python3-dev', 'libz-dev']
when 'centos'
  packages = ['gcc', 'g++', 'make', 'qt', 'qt-devel', 'python36-libs', 'python36-devel']
end

packages.each{|p|
  package p do
    action :install
  end
}

template '/usr/local/bin/klayout' do
  source 'klayout'
  owner 'root'
  group 'root'
  mode 00755
  action :create
end

bash 'build klayout' do
  install_path = '/usr/bin/klayout'
  cwd '/usr/local/src/klayout'
  code <<-EOF
    ./build.sh -ruby /opt/chef/embedded/bin/ruby
    make && make install
  EOF
  not_if { ::File.exist? install_path }
end

