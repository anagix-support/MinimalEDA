#
# Cookbook:: yosys
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'iverilog'

git '/usr/local/src/yosys' do
  repository 'https://github.com/cliffordwolf/yosys.git'
  revision 'master'
  action :sync
end

packages = ['clang', 'python3', 'tcl-dev', 'libreadline-dev', 'libffi-dev', 'mercurial-git', 'gawk']
packages.each{|p|
  package p do
    action :install
  end
}

bash 'build yosys' do
  install_path = '/usr/local/bin/yosys'
  cwd '/usr/local/src/yosys'
  code <<-EOF
    make config-gcc
    make && make install
  EOF
  not_if { ::File.exist? install_path }
end

