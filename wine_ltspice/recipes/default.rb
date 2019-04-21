#
# Cookbook Name:: wine_ltspice
# Recipe:: default
#
# Copyright 2013, Anagix Corp.
#
# All rights reserved - Do Not Redistribute
#
#### Install LTspice ####

include_recipe 'anagix_init'

if RUBY_PLATFORM =~ /darwin/
  alb_dist_path = 'http://alb.anagix.com:8180/dist/MacOSX/'
  install_path = '/Users/anagix/anagix_tools'
elsif RUBY_PLATFORM =~ /freebsd/
  alb_dist_path = 'http://alb.anagix.com:8180/dist/freebsd/'
  install_path = '/usr/local/anagix_tools'
elsif RUBY_PLATFORM =~ /x86_64-linux/
  alb_dist_path = 'http://alb.anagix.com:8180/dist/x86_64/'
  install_path = '/usr/local/anagix_tools'
else # elsif RUBY_PLATFORM =~ /i686-linux/
  alb_dist_path = 'http://alb.anagix.com:8180/dist/'
  install_path = '/usr/local/anagix_tools'
end

imagemagick = 'imagemagick'
x11apps = 'x11-apps'
if ['centos', 'redhat'].include? node[:platform]
  imagemagick = 'ImageMagick'
  x11apps = 'xorg-x11-apps'
end

targets = ['xauth', x11apps, imagemagick]

if node[:platform_family] == 'rhel'
  if node[:platform_version] >= '7.0'
    remote_file '/tmp/winerpm.tgz' do
      source File.join alb_dist_path, 'winerpm.tgz'
      owner 'anagix'
      group 'anagix'
      action :create
      not_if { ::File.exist? '/tmp/winerpm.tgz' }
    end
    bash 'localinstall wine' do
      cwd '/tmp'
      user 'root'
      code <<-EOH
      tar xzf winerpm.tgz
      cd winerpm
      yum -y localinstall *.rpm
      EOH
    end
  elsif node[:platform] == 'redhat'
    template '/etc/yum.repos.d/epel-bootstrap.repo' do
      # see: http://stackoverflow.com/questions/14016286/how-to-programmatically-install-the-latest-epel-release-rpm-without-knowing-its
      source 'epel-bootstrap.repo'
      action :create
    end
    
    bash 'install wien from epel' do
      code <<-EOH
        yum --enablerepo=epel -y install epel-release
        rm -f /etc/yum.repos.d/epel-bootstrap.repo
        yum install wine --enablerepo=epel
        EOH
    end
  elsif node[:platform] == 'centos'
    targets << 'epel-release'
    targets << 'wine'
  end
elsif node[:platform_family] == 'debian'
  if node[:platform] == 'ubuntu'
    wine_repo = 'https://dl.winehq.org/wine-builds/ubuntu/'
  elsif node[:platform] == 'linuxmint'
    if node[:platform_version] >= '8'
      wine_repo = "'deb https://dl.winehq.org/wine-builds/ubuntu/ xenial main'"
    else # <= '7'
      wine_repo = "'deb https://dl.winehq.org/wine-builds/ubuntu/ trusty main'"
    end
  end
  bash "localinstall wine on #{node[:platform]}" do
    cwd '/tmp'
    user 'root'
    code <<-EOH
      dpkg --add-architecture i386
      #      wget -nc https://dl.winehq.org/wine-builds/Release.key
      #      apt-key add Release.key
      wget -nc https://dl.winehq.org/wine-builds/winehq.key
      apt-key add winehq.key
      apt-add-repository #{wine_repo}
      apt-get update
      apt-get install -y --install-recommends winehq-stable
   EOH
  end
  targets << 'wine' if `which wine` == '' && !File.exist?('/usr/bin/wine')
else
  targets << 'wine' if `which wine` == ''
end

targets.each{|pkg|
  package pkg do
    action :install
  end
}

# note: 'ploticus' needs to be installed from source

template File.join(install_path, 'bin/install_ltspice') do
  # ltspice installation needs X which may not available during Vagrant installation
  source 'install_ltspice'
  owner 'anagix'
  group 'anagix'
  mode 00755
  action :create
end

#=begin
## this does not work because X which may not available during Vagrant installation
#ruby_block 'Install LTspice' do
#  block do
#    target_dir = '/export/home/anagix/.wine/drive_c/Program Files/LTC/LTspiceIV'
#    unless File.directory? target_dir
#      Dir.chdir('/tmp'){
#        system 'wget http://ltspice.linear.com/software/LTspiceIV.exe' unless File.exist? 'LTspiceIV.exe'
#        system 'wine ./LTspiceIV.exe'
#        puts 'LTspice installed'
#      }
#    end
#    Dir.chdir target_dir
#    if File.exist? 'ltsputil.exe'
#      puts 'Nothing to do --- ltspice and ltsputil have been already installed'
#    else
#      system 'wget http://alb.anagix.com:8180/dist/ltsputil.exe && chmod +x ltsputil.exe'
#      puts "ltsputil.exe installed under #{Dir.pwd}" if File.exist? 'ltsputil.exe'
#    end
#  end
#end
#=end
