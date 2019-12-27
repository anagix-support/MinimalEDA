#
# Cookbook Name:: alta_env
# Recipe:: default
#
# Copyright 2013, Anagix Corp.
#
# All rights reserved - Do Not Redistribute
#

### install gems for alta ### 

raise "*** alta_env does not make sense for #{node[:platform]}" unless RUBY_PLATFORM =~ /mswin32|mingw/

alb_dist_path = 'http://alb.anagix.com:8180/dist/'
install_path = File.dirname(File.dirname `where ruby.exe`.chop)

['activesupport', 'mechanize', 'archive-tar-minitar', 'github_api', 'gitlab', 'clipboard'].each{|g|
  gem_package g do
#    gem_binary 'c:\\opscode\\chef-workstation\\embedded\\bin\\gem'
    gem_binary File.join(install_path, 'bin', 'gem').gsub('/', '\\')   # was needed with chef client 14.14.29
    package_name g
  end
}

if RUBY_VERSION <= '1.9.3'
  gem_package 'qtbindings' do
    package_name 'qtbindings'
    version "4.8.3.0"
  end
else
  gem_package 'qtbindings' do
    package_name 'qtbindings'
  end
end

# Note: qtbindigs with version nil does not work with Windows
#       maybe version with extra info like "4.8.4.0-x86-mingw32" is needed

gem_package 'rubyzip' do
  package_name 'rubyzip'
#  options '--no-ri --no-rdoc'
#  version '0.9.9' --- causes 'no such file zip error' w/ the latest windows cookbook
   version '>=1.0.0'
end

gem_package 'zip-zip' do
  package_name 'zip-zip'
end

temp_dir = 'c:/opscode/temp'

directory temp_dir do
  action :create
end

### install alta ###

remote_file File.join(temp_dir, 'alta.zip') do
  source File.join alb_dist_path, 'alta.zip'
  action :create
end

windows_zipfile install_path do
  source File.join(temp_dir, 'alta.zip')
  action :unzip
  overwrite true
#  not_if {::File.exists? File.join(install_path, 'bin', 'alta.bat')}
end

require 'fileutils'

['alta.bat', 'alta_slave.bat'].each{|file|
  template File.join(install_path, 'bin', file) do
    variables variables: {:install_path => install_path}
    source file+'.erb'
    action :create
  end
}

template File.join(install_path, 'lib', 'ruby', 'site_ruby', 'ruby_installer.rb') do
  source 'ruby_installer.rb'
  action :create
end

### install ploticus ###

=begin
remote_file File.join(temp_dir, 'pl.zip') do
  source File.join alb_dist_path, 'pl.zip'
  action :create
end

windows_zipfile File.join(install_path, 'bin') do
  source File.join(temp_dir, 'pl.zip')
  action :unzip
  not_if {::File.exists? File.join(install_path, 'bin', 'pl.exe')}
end
=end

remote_file File.join File.join(install_path, 'bin', 'pl.exe') do
  source 'http://alb.anagix.com:8180/dist/pl.exe'
  action :create_if_missing
end

### install snaka's gyazowin ###

remote_file File.join File.join(install_path, 'bin', 'gyazowin.exe') do
#  source 'http://github.com/downloads/snaka/Gyazowin/gyazowin.exe'
  source 'http://alb.anagix.com:8180/dist/gyazowin.exe'
  action :create_if_missing
end

### alta.conf ###
=begin
template File.join(File.expand_path('~'), 'alta.conf') do # Dir.home could work after ruby 1.9.3
  source 'alta.conf.erb'
  action :create_if_missing
end
=end

### ltspice ###

unless File.directory?(File.join ENV['PROGRAMFILES'], 'LTC', 'LTspiceXVII')
  windows_package 'LTspice' do
    source 'http://ltspice.analog.com/software/LTspiceXVII.exe'
    action :install
  end
end

remote_file File.join File.join(install_path, 'bin', 'ltsputil.exe') do
  source File.join alb_dist_path, 'ltsputil.exe'
  action :create_if_missing
end

remote_file File.join File.join(install_path, 'bin', 'ltsputil17raw4.exe') do
  source File.join alb_dist_path, 'ltsputil17raw4.exe'
  action :create_if_missing
end
