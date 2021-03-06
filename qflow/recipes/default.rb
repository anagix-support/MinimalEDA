#
# Cookbook:: qflow
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

current = 'qflow-1.3.16'

foods = ['qrouter', 'graywolf', 'yosys', 'ngspice', 'irsim', 'iverilog', 'dinotrace', 'netgen']
foods.each{|f|
  include_recipe f
}

remote_file "/usr/local/src/#{current}.tgz" do
  source "http://opencircuitdesign.com/qflow/archive/#{current}.tgz"
  mode '0755'
end

bash 'extract qflow' do
  cwd '/usr/local/src'
  code <<-EOH
    tar xzf /usr/local/src/#{current}.tgz
  EOH
  not_if { ::File.exist? "/usr/local/src/#{current}" }
end

packages = ['tcsh','make']
case node[:platform]
when 'ubuntu', 'debian'
  packages << 'python3-tk'

  apt_update 'update' do
    action :update
  end

when 'centos'
  packages << 'python35u-tkinter'
end

packages.each{|p|
  package p do
    action :install
  end
}

bash 'build qflow' do
  install_path = '/usr/local/bin/qflow'
  cwd "/usr/local/src/#{current}"
  code <<-EOF
    ./configure
    make && make install
  EOF
  not_if { ::File.exist? install_path }
end
