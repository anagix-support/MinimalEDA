#
# Cookbook:: graywolf
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

git '/usr/local/src/graywolf' do
  repository 'https://github.com/rubund/graywolf.git'
  revision 'master'
  action :sync
end

packages = ['cmake', 'libgsl-dev', 'libx11-dev']
packages.each{|p|
  package p do
    action :install
  end
}

bash 'build graywolf' do
  install_path = '/usr/local/bin/graywolf'
  cwd '/usr/local/src/graywolf'
  code <<-EOF
    PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig cmake .
    make && make install
  EOF
  not_if { ::File.exist? install_path }
end
