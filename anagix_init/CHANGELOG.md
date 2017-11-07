# CHANGELOG for anagix_init

This file is used to list changes made in each version of anagix_init.

## 0.1.0:

* Initial release of anagix_init

- - - 
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.

## 0.1.1:

* template .bashrc_anagix.erb and .bashrc_vagrant.erb to ease startup and halt ALB server

## 0.1.2:	
* add aliases to ~/vagrant/.bashrc: alb_start, alb_stop, alb_status, alb_log, alb_tail
* loadkeys jp in ~/vagrant/.bashrc

## 0.1.3:
* appended below to .emacs 
  (setq frame-background-mode 'dark)  ; to change sphinx title background color

## 0.1.4:
* Direct installation (w/o Vagrant) for both Ubuntu and CentOS

## 0.1.5:
* loadkeys moved to ~vagrant/.bash_profile, .bashrc to source .bashrc_alb

## 0.1.6:
* start_alb changed not to invoke vncserver	

## 0.1.7:
* create /home/anagix/.gitconfig
* /usr/local/anagix_tools/qt-4/lib added to LD_LIBRARY_PATH
	
## 0.1.8:
* defined node['home_anagix'] = '/home/anagix'
	
## 0.2.0:
	* do not use 'ruby-devel' because it causes system ruby installation
	* recovered lost files under templates/default
## 0.3.0:
	* dependence on 'apt' and 'build-essential' removed
