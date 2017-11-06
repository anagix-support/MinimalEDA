#
# Cookbook Name:: alb_db_bkup
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

HOME = '/home/anagix'

directory(File.join HOME, 'BKUP') do
  owner 'anagix'
  group 'anagix'
  mode 00755
  action :create
end

directory(File.join HOME, 'BKUP', 'ALB_DB') do
  owner 'anagix'
  group 'anagix'
  mode 00755
  action :create
end

template (File.join HOME, 'BKUP', 'ALB_DB', 'alb_db_bkup') do
  source 'alb_db_bkup'
  owner 'anagix'
  group 'anagix'
  mode 00755
  action :create
end

bash "git init at #{HOME}/BKUP/ALB_DB" do
  not_if { ::File.exist? File.join(HOME, 'BKUP', 'ALB_DB', '.git')}
  cwd File.join(HOME, 'BKUP', 'ALB_DB')
  user 'anagix'
  code <<-EOH
    export HOME=#{HOME}
    export PATH=/usr/local/anagix_tools/bin:$PATH
    git init
  EOH
end

bash 'create crontab' do
  not_if("crontab -l | grep alb_db_bkup", :user => 'anagix')
  user 'anagix'
  code <<-EOH
    crontab -l > #{HOME}/BKUP/crontab.txt
    echo '00,20,40 * * * * #{HOME}/BKUP/ALB_DB/alb_db_bkup 2>&1 > /dev/null' >> #{HOME}/BKUP/crontab.txt
    echo '15 * * * * (cd #{HOME}/BKUP/ALB_DB; /usr/bin/git gc) 2>&1 >/dev/null' >> #{HOME}/BKUP/crontab.txt
    crontab #{HOME}/BKUP/crontab.txt
  EOH
end
