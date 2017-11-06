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

['activesupport', 'mechanize', 'archive-tar-minitar', 'github_api', 'gitlab'].each{|g|
  gem_package g do
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

alb_dist_path = 'http://alb.anagix.com:8180/dist/'
install_path = 'c:/opscode/chef/embedded'
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

=begin
# no longer needed 
ruby_block 'move files' do
  block do
    Dir.chdir(File.join install_path, 'lib', 'ruby', 'site_ruby'){
      FileUtils.mv Dir.glob('1.8/*'), '1.9.1'
    }
  end
end
=end

if RUBY_VERSION <= '1.9.3'
  ruby_block 'remove files under 1.9.1' do
    block do
      Dir.chdir(File.join install_path, 'lib', 'ruby', 'site_ruby'){
        files = Dir.glob('*')
        files.each{|f|
          next if File.directory? f
          Dir.chdir('1.9.1'){
            File.delete f if File.exist? f
          }
        }
      }
    end
  end
end

['alta.bat', 'alta_slave.bat'].each{|file|
  template File.join(install_path, 'bin', file) do
    source file
    action :create
  end
}

### install ploticus ###

remote_file File.join(temp_dir, 'pl.zip') do
  source File.join alb_dist_path, 'pl.zip'
  action :create
end

windows_zipfile File.join(install_path, 'bin') do
  source File.join(temp_dir, 'pl.zip')
  action :unzip
  not_if {::File.exists? File.join(install_path, 'bin', 'pl.exe')}
end

### install snaka's gyazowin ###

remote_file File.join File.join(install_path, 'bin', 'gyazowin.exe') do
#  source 'http://github.com/downloads/snaka/Gyazowin/gyazowin.exe'
  source 'http://alb.anagix.com:8180/dist/gyazowin.exe'
  action :create_if_missing
end

### alta.conf ###

template File.join(File.expand_path('~'), 'alta.conf') do # Dir.home could work after ruby 1.9.3
  source 'alta.conf.erb'
  action :create_if_missing
end

### ltspice ###

unless File.exist?(File.join ENV['PROGRAMFILES'], 'LTC', 'LTspiceIV', 'scad3.exe')
  windows_package 'LTspice' do
    source 'http://ltspice.linear.com/software/LTspiceIV.exe'
    action :install
  end
end

remote_file File.join File.join(install_path, 'bin', 'ltsputil.exe') do
  source File.join alb_dist_path, 'ltsputil.exe'
  action :create_if_missing
end
