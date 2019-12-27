#
# Cookbook:: mineda_linux
# Recipe:: default
#
# Copyright:: 2019, Anagix Corp., All Rights Reserved.

['etckeeper', 'tigervnc-viewer', 'openssh-server', 'screen'].each{|pkg|
  package pkg do
    action :install
  end
}

bash 'install kicad' do
  code <<-EOH
      add-apt-repository --yes ppa:js-reynaud/kicad-5.1
      apt install --yes --install-recommends kicad 
      EOH
#  action :nothing
end

=begin
bash 'install klayout' do # this requires libruby2.5 which is unwanted
  code <<-EOH
      cd /tmp
      wget https://www.klayout.org/downloads/Ubuntu-18/klayout_0.26.2-1_amd64.deb
      dpkg -i klayout_0.26.2-1_amd64.deb
      EOH
end
=end

include_recipe 'klayout_source_build'

bash 'install glade' do
  code <<-EOH
      cd /tmp
      wget http://www.peardrop.co.uk/glade/glade4_linux64_ub18.tar.gz
      cd /opt
      tar xzf /tmp/glade4_linux64_ub18.tar.gz
      EOH
end
