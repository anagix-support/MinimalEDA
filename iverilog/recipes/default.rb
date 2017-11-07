#
# Cookbook:: iverilog
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# git clone https://github.com/steveicarus/iverilog.git

package "git" do
  action :install
end

git '/usr/local/src/iverilog' do
  repository 'https://github.com/steveicarus/iverilog.git'
  revision 'master'
  action :sync
end

case node[:platform]
when 'ubuntu'
  packages = ['build-essential', 'autoconf', 'flex', 'bison', 'gperf']
when 'centos'
  packages = ['gperf', 'autoconf', 'gcc', 'flex', 'bison', 'gcc-c++', 'make']
end

packages.each{|p|
  package p do
    action :install
  end
}

bash 'build iverilog' do
  install_path = '/usr/local/bin/iverilog'
  cwd '/usr/local/src/iverilog'
  code <<-EOF
   autoconf
    ./configure
    make && make install
  EOF
  not_if { ::File.exist? install_path }
end
