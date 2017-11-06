#
# Cookbook:: magic
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

remote_file '/usr/local/src/magic-8.1.185.tgz' do
  source 'http://opencircuitdesign.com/magic/archive/magic-8.1.185.tgz'
  mode '0755'
end

bash 'extract magic' do
  cwd '/usr/local/src'
  code <<-EOH
    tar xzf /usr/local/src/magic-8.1.185.tgz
  EOH
  not_if { ::File.exist? '/usr/local/src/magic-8.1.185' }
end

packages = ['csh']
packages.each{|p|
  package p do
    action :install
  end
}

bash 'build magic' do
  install_path = '/usr/local/bin/magic'
  cwd '/usr/local/src/magic-8.1.185'
  code <<-EOF
    ./configure
    make && make install
  EOF
  not_if { ::File.exist? install_path }
end
  
