#
# Cookbook Name:: anagix_init
# Recipe:: default
#
# Copyright 2013-2017, Anagix Corp.
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'build-essential'

#### User and Home ###

packages = ['git']
case node[:platform]
when 'ubuntu', 'debian', 'linuxmint'
  #  packages = ['ruby-dev', 'git']      # changed not to use ruby-dev because it installs ruby as well
  include_recipe 'apt::default'  # expected to perform apt-get update
when 'centos', 'redhat'
  # packages = ['ruby-devel', 'git']
end

packages.each{|p|
  package p do
    action :install
  end
}

gem_package 'ruby-shadow' do
  package_name 'ruby-shadow'
  options "--no-ri --no-rdoc"
end

user 'anagix' do
  home node['anagix_home']
  password '$1$R9Plfp46$tVekD5RbEGYPA6x1DunvA/'   # use openssl passwd -1 'plainpasswd'
  shell '/bin/bash'
  action :create
  not_if 
end

directory node['anagix_home'] do
  owner 'anagix'
  group 'anagix'
  mode 00755
  action :create
end

template File.join(node['anagix_home'], '.gitconfig') do
  owner 'anagix'
  group 'anagix'
  source '.gitconfig'
  action :create_if_missing
end

users = ['anagix']
if File.exist? '/home/vagrant' 
  users << 'vagrant'

  execute 'loadkeys in ~vagrant/.bash_profile' do
    user 'vagrant'
#    command "echo 'sudo loadkeys jp#{node[:platform] == 'centos'? '106':''}' >> ~vagrant/.bash_profile"
    command "echo 'sudo loadkeys jp#{['centos', 'redhat'].include? node[:platform] ? '106':''}' >> ~vagrant/.bash_profile"
    not_if "grep loadkeys ~vagrant/.bash_profile"
  end
end

users.each{|user|
  template File.join(File.dirname(node['anagix_home']), user, '.bashrc_alb') do
    owner user
    group user
    source ".bashrc_#{user}.erb"
#    action :create_if_missing
    action :create # rewrite .bashrc 
  end

  bashrc_path = File.join(File.dirname(node['anagix_home']), user, '.bashrc')
  execute "append source ~/.bashrc_alb to #{bashrc_path}" do
    user user
    command "echo . '~'/.bashrc_alb >> #{bashrc_path}"
    not_if "grep .bashrc_alb #{bashrc_path}"
  end
}

%w[.screenrc .cdsinit .emacs].each{|file|
  users.each{|user|
    template File.join(File.dirname(node['anagix_home']), user, file) do
      owner user
      group user
      source file
      action :create_if_missing
    end
  }
}

