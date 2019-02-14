#
# Cookbook:: gtkwave
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

current = 'gtkwave-3.3.99' # gtkwave-3.3.86

remote_file "/usr/local/src/#{current}.tar.gz" do
  source "https://sourceforge.net/projects/gtkwave/files/#{current}/#{current}.tar.gz"
  mode '0755'
end

bash 'extract gtkwave' do
  cwd '/usr/local/src'
  code <<-EOH
    tar xzf /usr/local/src/#{current}.tar.gz
  EOH
  not_if { ::File.exist? "/usr/local/src/#{current}" }
end

case node[:platform]
when 'ubuntu', 'debian'
  packages = ['liblzma-dev', 'libgtk2.0-dev', 'tcl-dev', 'tk-dev', 'gperf']
when 'centos'
  packages = ['tcl-devel', 'tk-devel', 'xz-devel', 'gperf', 'gcc-c++', 'gtk2-devel', 'make']
end
packages.each{|p|
  package p do
    action :install
  end
}

bash 'build gtkwave' do
  install_path = '/usr/local/bin/gtkwave'
  cwd "/usr/local/src/#{current}"
  code <<-EOF
    ./configure
    make && make install
  EOF
  not_if { ::File.exist? install_path }
end

