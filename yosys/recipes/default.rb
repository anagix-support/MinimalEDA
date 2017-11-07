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

case node[:platform]
when 'ubuntu'
  packages = ['clang', 'python3', 'tcl-dev', 'libreadline-dev', 'libffi-dev', 'mercurial-git', 'gawk']
when 'centos'
  packages = ['wget', 'tcl-devel', 'readline-devel', 'bison', 'libffi-devel', 'gcc', 'zip']
end

packages.each{|p|
  package p do
    action :install
  end
}
case node[:platform]
when 'centos'
  remote_file '/usr/local/src/gcc-4.8.5.tar.gz' do
    source 'http://www.netgull.com/gcc/releases/gcc-4.8.5/gcc-4.8.5.tar.gz'
    mode '0755'
  end

  bash 'extract gcc' do
    cwd '/usr/local/src'
    code <<-EOH
      tar xzf /usr/local/src/gcc-4.8.5.tar.gz
    EOH
    not_if { ::File.exist? '/usr/local/src/gcc-4.8.5' }
  end

  bash 'update gcc' do
    cwd '/usr/local/src/gcc-4.8.5'
    code <<-EOF
      ./contrib/download_prerequisites
      ./configure --prefix=/usr --disable-bootstrap --disable-multilib
      make && make install
    EOF
  end

  bash 'install ius' do
    code <<-EOF
      curl -s https://setup.ius.io/|sh
    EOF
    not_if 'rpm -qa |grep ius-release*' 
  end
  packages = ['hg-git', 'python35u']
    packages.each{|p|
      package p do
        action :install
      end
    }  
  link '/usr/bin/python3' do
    to '/usr/bin/python3.5'
  end

  bash 'change verilog_parser.y' do
    cwd '/usr/local/src/yosys/frontends/verilog'
    code <<-EOF
      sed -i -e "142,143s:^:/*:" /usr/local/src/yosys/frontends/verilog/verilog_parser.y
      sed -i -e "142,143s:$:*/:" /usr/local/src/yosys/frontends/verilog/verilog_parser.y
    EOF
  end
end

bash 'build yosys' do
  install_path = '/usr/local/bin/yosys'
  cwd '/usr/local/src/yosys'
  code <<-EOF
    make config-gcc
    make && make install
  EOF
  not_if { ::File.exist? install_path }
end

