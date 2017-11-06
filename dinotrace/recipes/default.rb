#
# Cookbook:: dinotrace
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

remote_file '/usr/local/src/dinotrace-9.4e.tgz' do
  source 'https://www.veripool.org/ftp/dinotrace-9.4e.tgz'
  mode '0755'
end

bash 'extract magic' do
  cwd '/usr/local/src'
  code <<-EOH
    tar xzf /usr/local/src/dinotrace-9.4e.tgz
  EOH
  not_if { ::File.exist? '/usr/local/src/dinotrace-9.4e' }
end

packages = ['libmotif-dev']
packages.each{|p|
  package p do
    action :install
  end
}

bash 'build dinotrace' do
  install_path = '/usr/local/bin/dinotrace'
  cwd '/usr/local/src/dinotrace-9.4e'
  code <<-EOF
    ./configure
    make && make install
  EOF
  not_if { ::File.exist? install_path }
end
