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
when 'ubuntu', 'debian'
  packages = ['g++', 'make', 'autoconf', 'flex', 'bison', 'gperf']
when 'centos'
  if node['platform_version'].to_i == 6 then
    packages = ['gperf', 'autoconf', 'gcc', 'flex', 'gcc-c++']
  elsif node['platform_version'].to_i == 7 then
    packages = ['gperf','autoconf','gcc','flex', 'bison','gcc-c++','make']
  end
end

packages.each{|p|
  package p do
    action :install
  end
}

case node[:platform]
when 'centos'
  if node['platform_version'].to_i == 6 then
    remote_file '/usr/local/src/bison-3.0.4.tar.gz' do
      source 'http://ftp.gnu.org/gnu/bison/bison-3.0.4.tar.gz'
      mode '0755'
    end

    bash 'extract bison' do
     cwd '/usr/local/src'
     code <<-EOH
       tar xzf /usr/local/src/bison-3.0.4.tar.gz
       EOH
     not_if { ::File.exist? '/usr/local/src/bison-3.0.4' }
    end

    bash 'build bison' do
      install_path = '/usr/local/bin/bison'
      cwd '/usr/local/src/bison-3.0.4'
      code <<-EOF
        ./configure 
        make && make install
      EOF
    not_if { ::File.exist? install_path }
    end
   
    link '/usr/bin/bison' do
     to '/usr/local/bin/bison'
    end

  end
end

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
