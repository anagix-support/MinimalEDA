#
# Cookbook:: qflow
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

foods = ['qrouter', 'graywolf', 'yosys', 'ngspice', 'irsim', 'iverilog', 'dinotrace', 'netgen']
foods.each{|f|
  include_recipe f
}

remote_file '/usr/local/src/qflow-1.1.74.tgz' do
  source 'http://opencircuitdesign.com/qflow/archive/qflow-1.1.74.tgz'
  mode '0755'
end

bash 'extract qflow' do
  cwd '/usr/local/src'
  code <<-EOH
    tar xzf /usr/local/src/qflow-1.1.74.tgz
  EOH
  not_if { ::File.exist? '/usr/local/src/qflow-1.1.74' }
end

packages = ['tcsh','make']
packages.each{|p|
  package p do
    action :install
  end
}

bash 'build qflow' do
  install_path = '/usr/local/bin/qflow'
  cwd '/usr/local/src/qflow-1.1.74'
  code <<-EOF
    ./configure
    make && make install
  EOF
  not_if { ::File.exist? install_path }
end
