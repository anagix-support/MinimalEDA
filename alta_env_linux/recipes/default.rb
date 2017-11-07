#
# Cookbook Name:: alta_env_linux
# Recipe:: default
#
# Copyright 2013, Anagix Corp.
#
# All rights reserved - Do Not Redistribute
#

# include_recipe 'build-essential'
include_recipe 'openssl'
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

unless RUBY_PLATFORM =~ /darwin/
  directory install_path do
    owner 'anagix'
    group 'anagix'
    mode 00755
    action :create
  end
end

check_point = {'anagix_bin.tgz' => File.join(install_path, 'bin'), 
  'alb_lib.tgz' => File.join(install_path, 'lib/ruby/site_ruby/alb_version.rb'),
  'ade_express.tgz' => File.join(install_path, 'lib/ruby/site_ruby/alb_gear.rb'), 
  'alta.tgz'=> File.join(install_path, 'lib/ruby/site_ruby/alta.rb')
}

tgz_packs = %w[alb_lib.tgz ade_express.tgz alta.tgz] # qucs.tgz
tgz_packs.unshift('anagix_bin.tgz') unless File.exist? '/usr/bin/startkde' # use system's ruby with KDE
# tgz_packs << 'libruby.tgz' unless ['centos', 'redhat'].include? node[:platform]

tgz_packs.each{|src|
  remote_file File.join('/tmp', src)  do
    source File.join alb_dist_path, src
    owner 'anagix'
    group 'anagix'
    action :create
    not_if { ::File.exists?(File.join '/tmp', src) }
  end

  unless check_point[src] && File.exists?(check_point[src])
    bash "extract #{src}" do
      cwd File.join(install_path, '..')
      user 'anagix'
      code <<-EOH
        tar xzf #{File.join '/tmp', src}
        EOH
    end
  end
}

case node[:platform]
when 'ubuntu', 'debian', 'linuxmint'
  packages = ['wget', 'cmake',  'libgl1-mesa-dev', 'libglu1-mesa-dev', 'libxml2-dev', 'libxslt-dev', 'libqt4-dev', 'zlib1g-dev', 'software-properties-common', 'apt-transport-https']
when 'centos', 'redhat'
  packages = ['wget', 'cmake', 'libX11-devel', 'mesa-libGL-devel', 'mesa-libGLU-devel', 'libxml2-devel', 'libxslt-devel', 'qt4', 'qt4-devel', 'which']
end

# puts "*** node[:platform] = #{node[:platform]}"

packages.each{|pkg|
  package pkg do 
    action :install
  end
}

unless RUBY_PLATFORM =~ /darwin/
  link File.join(node['anagix_home'], 'anagix_tools') do
    owner 'anagix'
    to install_path
    not_if "test -L #{File.join(node['anagix_home'], 'anagix_tools')}"
  end
end

gem_packages = ['activesupport', 'mechanize', 'rubyzip', 'zip-zip', 'archive-tar-minitar',
               'github_api', 'gitlab']

if node[:platform_family] == 'debian' && File.exist?('/usr/bin/startkde') # KDE is installed
  package 'ruby-qt4' do  # use system's ruby
    action :install
  end

  gem_packages.each{|g|
    gem_package g do
      package_name g
      options "--no-ri --no-rdoc"
    end
  }
else                     # use chef's ruby
#  binaries = ['ruby', 'gem', 'irb'].each{|bin|
#    link "/usr/local/anagix_tools/bin/#{bin}" do
#      owner 'anagix'
#      to "/opt/chef/embedded/bin/#{bin}"
#      not_if { ::File.exist? "/usr/local/anagix_tools/bin/#{bin}" }
#    end
#  }

#=begin  
#  remote_file File.join('/tmp', 'qt4.tgz')  do
#    source File.join alb_dist_path, 'qt4.tgz'
#    owner 'anagix'
#    mode 00600
#    action :create
#    not_if { ::File.exist? '/tmp/qt4.tgz' }
#    notifies :run, "bash[extract qt4.tgz]", :immediately
#  end
#
#  bash "extract qt4.tgz" do
#    cwd File.join(install_path, '..')
#    user 'anagix'
#    code <<-EOH
#        tar xzf #{File.join '/tmp', 'qt4.tgz'}
#        EOH
#    action :nothing
#  end
#=end

  gem_packages << ['qtbindings', '4.8.6.2']

  gem_packages.each{|g|
    v = ''
    if g.class == Array
      v = '-v='+g[1]
      g = g[0]
    end
    gem_package g do
      options "#{v} --no-ri --no-rdoc"
    end
  }
end
  
# unless node[:platform_family] == 'rhel' && node[:platform_version] >= '7.0' # wine64 in centos7 is useless
include_recipe 'wine_ltspice'
# end
# include_recipe 'anagix_init'
