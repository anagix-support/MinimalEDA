#
# Cookbook:: mineda_win
# Recipe:: default
#
# Copyright:: 2019, Anagix Corp., All Rights Reserved.

temp_dir = 'c:/opscode/temp'

directory temp_dir do
  action :create
end

remote_file File.join(ENV['HOME'], 'Downloads', 'vncviewer-1.10.0.exe') do
  source 'https://bintray.com/tigervnc/stable/download_file?file_path=vncviewer-1.10.0.exe'
#  source 'https://dl.bintray.com/tigervnc/stable/vncviewer-1.10.0.exe'
  action :create
end
  
windows_package 'X2Go Client for Windows' do
  source 'http://code.x2go.org/releases/X2GoClient_latest_mswin32-setup.exe'
  installer_type :nsis
  action :install
end

windows_package 'VcXsrv' do
  source 'https://sourceforge.net/projects/vcxsrv/files/vcxsrv-64.1.20.5.1.installer.exe'
  installer_type :nsis
  action :install
end

windows_package 'klayout' do
  source 'https://www.klayout.org/downloads/Windows/klayout-0.26.1-win64-install.exe'
  installer_type :nsis
  action :install
end

windows_package 'kicad' do
  source 'https://github.com/KiCad/kicad-winbuilder/releases/download/5.1.5/kicad-5.1.5_3-x86_64.exe'
  installer_type :nsis
  action :install
end

zip_sources = {glade: ['http://www.peardrop.co.uk/glade/glade4_win64.zip', 'c:/', 'glade4_win64/glade.exe'], # name: [source, target, check]
               ctrl2cap: ['https://download.sysinternals.com/files/Ctrl2Cap.zip', 'c:/Ctrl2cap'],
               emacs: ['http://ftp.gnu.org/pub/gnu/emacs/windows/emacs-26/emacs-26.3-x86_64.zip', 'c:/emacs-26.3-x86_64'] 
              }

zip_sources.each_pair{|name, address|
  unless File.exist?(address[2].nil? ? address[1] : File.join(address[1], address[2]))
    remote_file File.join(temp_dir, name.to_s+'.zip') do
      source address[0]
      action :create
    end
    
    windows_zipfile address[1] do
      source File.join(temp_dir, name.to_s+'.zip')
      action :unzip
      overwrite true
    end
  end
}
