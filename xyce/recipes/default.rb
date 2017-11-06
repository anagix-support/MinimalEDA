#
# Cookbook:: xyce
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

remote_file '/usr/local/src/trilinos-12.6.3-Source.tar.gz' do
  source 'http://trilinos.csbsju.edu/download/files/trilinos-12.6.3-Source.tar.gz'
  mode '0755'
end

bash 'extract trilinos-12.6.3' do
  cwd '/usr/local/src'
  code <<-EOH
    tar xzf /usr/local/src/trilinos-12.6.3-Source.tar.gz
  EOH
  not_if { ::File.exist? '/usr/local/src/trilinos-12.6.3-Source' }
end

packages = ['gfortran', 'cmake', 'bison', 'flex', 'libfftw3-dev', 'libsuitesparse-dev', 'libblas-dev', 'liblapack-dev', 'libtool']
packages.each{|p|
  package p do
    action :install
  end
}

directory '/usr/local/src/trilinos-12.6.3-Source/build' do
  owner 'root'
  mode 00755
  action :create
end

template '/usr/local/src/trilinos-12.6.3-Source/build/reconfigure' do
  source 'reconfigure'
  owner 'root'
  group 'root'
  mode 00755
  action :create
end

bash 'build trilinos' do
  install_path = '/usr/local/XyceLibs'
  cwd '/usr/local/src/trilinos-12.6.3-Source/build'
  code <<-EOH
    ./reconfigure
    make && make install
  EOH
  not_if { ::File.exist? install_path }
end

execute 'extract xyce' do
  install_path = '/usr/local/src/Xyce-6.7'
  cwd '/usr/local/src'
  command 'tar xzf /usr/local/src/Xyce-6.7.tar.gz'
  not_if { ::File.exist? install_path }
end

bash 'build xyce' do
  install_path = '/usr/local/bin/Xyce'
  cwd '/usr/local/src/Xyce-6.7'
  code <<-EOH
    CXXFLAGS=\"-O3 -std=c++11\" LDFLAGS=\"-L/usr/local/XyceLibs/Serial/lib\" CPPFLAGS=\"-I/usr/include/suitesparse -I/usr/local/XyceLibs/Serial/include\" ./configure --prefix=/usr/local
    make && make install
  EOH
  not_if { ::File.exist? install_path }
end


