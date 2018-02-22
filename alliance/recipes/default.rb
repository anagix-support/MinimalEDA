#
# Cookbook:: alliance
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

case node[:platform]
when 'ubuntu', 'debian'
  packages = %w( build-essential git gcc g++ autoconf automake libtool bison flex libx11-dev libxt-dev libxaw7-dev libxpm-dev libmotif-dev xfig imagemagick texlive texlive-pictures texlive-latex-extra transfig )
when 'centos'
  execute "yum update" do
    command "yum update"
    ignore_failure true
    action :nothing
  end
  execute "Development Tools" do
    command 'yum groupinstall "Development Tools"'
    ignore_failure true
    action :nothing
  end
  packages = %w(  git gcc autoconf automake libtool bison flex libX11-devel libXt-devel libXaw-devel libXpm-devel ImageMagick texlive texlive-latex openmotif-devel transfig )
end
packages.each{|pkg|
  package pkg do 
    action :install
  end
} 

SRC_DIR = '/usr/local/src/alliance' 
ALLIANCE_TOP = '/opt/alliance'

git SRC_DIR do
  repository 'https://www-soc.lip6.fr/git/alliance.git'
  reference 'master'
  action :checkout
end

directory ALLIANCE_TOP do
    action :create
end

if ['ubuntu', 'debian'].include? node[:platform] && node[:platform_version] >= '16.04'
  template File.join(SRC_DIR, 'fix-flex-2.6.patch') do
    source 'fix-flex-2.6.patch'
    action :create
  end
  
  execute 'patch for ubuntu' do
    cwd File.join(SRC_DIR, 'alliance/src/sea/src')
    command 'patch -b DEF_grammar_lex.l < ../../../../fix-flex-2.6.patch'
    not_if { ::File.exists? 'DEF_grammar_lex.l.orig' }
  end
end

execute 'autostuff' do
  cwd File.join(SRC_DIR, 'alliance/src')
  command './autostuff'
  not_if { ::File.exists? 'configure' }
end

directory File.join(SRC_DIR, 'build') do
  action :create
end

bash 'configure' do
  cwd File.join(SRC_DIR, 'build')
  code <<-EOT
    export ALLIANCE_TOP=#{ALLIANCE_TOP}
    export LD_LIBRARY_PATH=${ALLIANCE_TOP}/lib:${LD_LIBRARY_PATH}
    ../alliance/src/configure --prefix=$ALLIANCE_TOP --enable-alc-shared
    EOT
  not_if { ::File.exists? 'Makefile' }
end

bash 'make' do
  cwd File.join(SRC_DIR, 'build')
  code <<-EOT
    export ALLIANCE_TOP=#{ALLIANCE_TOP}
    export LD_LIBRARY_PATH=${ALLIANCE_TOP}/lib:${LD_LIBRARY_PATH}
    make -j1 install
    EOT
end
