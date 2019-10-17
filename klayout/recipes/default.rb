#
# Cookbook:: klayout
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

current = 'klayout-0.2.6'
klayout_dist_path = 'http://alb.anagix.com:8180/dist/ubuntu19.04'

remote_file File.join '/tmp', src = 'klayout.tgz' do
  source File.join klayout_dist_path, src
  owner 'anagix'
  group 'anagix'
  action :create
  not_if { ::File.exists?(File.join '/tmp', src) }
end

bash "extract #{src}" do
  cwd File.join(install_path, '..')
  user 'anagix'
  code <<-EOH
    tar xzf #{File.join '/tmp', src}
    EOH
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
  EOF
  not_if { ::File.exist? install_path }
end

