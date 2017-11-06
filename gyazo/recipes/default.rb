#
# Cookbook Name:: gyazo
# Recipe:: default
#
# Copyright 2013, Anagix Corp.
#
# All rights reserved - Do Not Redistribute
#
www_owner = 'www-data'
www_owner = 'apache' if node[:platform_family] == 'rhel'

bash 'change /var/www owner to apache recursively' do
  code <<-EOH
    chown -R #{www_owner} /var/www
    EOH
end

['/var/www/myGyazo', 
 '/var/www/myGyazo/data', '/var/www/myGyazo/db',
 '/var/www/cgi-bin'].each{|dir|
  directory dir do
    owner = www_owner
    group = www_owner
    mode '755'
    action :create
  end
}
  
template '/var/www/cgi-bin/upload.cgi' do
  source "upload.cgi.erb"
  owner = www_owner
  group = www_owner
  mode "755"
  action :create
end

template '/var/www/cgi-bin/printenv.cgi' do
  source 'printenv.cgi'
  owner = www_owner
  group = www_owner
  mode "755"
  action :create
end

if (['centos', 'redhat'].include? node[:platform]) && !File.exist?('/etc/yum.repos.d/epel.repo')
  template '/etc/yum.repos.d/epel-bootstrap.repo' do
    # see: http://stackoverflow.com/questions/14016286/how-to-programmatically-install-the-latest-epel-release-rpm-without-knowing-its
    source 'epel-bootstrap.repo'
    action :create
  end

  bash 'install epel' do
    code <<-EOH
        yum --enablerepo=epel -y install epel-release
        rm -f /etc/yum.repos.d/epel-bootstrap.repo
        EOH
  end
end

package 'xclip' do
  action :install
end
