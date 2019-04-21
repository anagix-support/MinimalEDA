# CHANGELOG for alta_env_linux

This file is used to list changes made in each version of alta_env_linux.

## 0.1.0:

* Initial release of alta_env_linux

## 0.1.1:

* Direct installation (w/o Vagrant) for both Ubuntu and CentOS
- - - 
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.

## 0.1.2:
* depends on build-essential and wine_ltspice
* development libraries corrected for qtbindings on centos
* qtbindings compilation corrected for 64bit version	

## 0.1.3:
* wget added	

## 0.1.4:
* QUCS for both centos (64bit) and debian (32bit)	

## 0.1.5:	
* rubyzip to use version 0.9.9, otherwise rubyzip requires ruby 1.9.2 error 	

## 0.1.6:	
	* Dependency fixed
## 0.1.7:
	* bug fix for KDE installed machines - bypass qt4 install, upload.cgi template bug fix
## 0.1.8:	
	* moved creating symlink /home/anagix/anagix_tools to install_path after including 'wine_ltspice'
## 0.1.9:
	* dependency on anagix_init revived
## 0.1.10:
	* ignore kde for CentOS, link existence check for /home/anagix/anagix_tools creation'
## 0.1.11:
	* dependecy on openssl added -- qt4 needs openssl and qtbindings fails w/o openssl
## 0.1.12:
	* check_point fixed
## 0.1.13:
	* moved creating symlink /home/anagix/anagix_tools to install_path before gem install qtbindigns etc'
## 0.1.14:
	* fixed qtbindings version to 4.8.3.0 because the latest qtbindings no longer support ruby 1.8.x
## 0.1.15:
	* defined node['anagix_home'] = '/home/anagix'
## 0.2.1:
	* updated for ALTA2 to work with ALB2
	* ruby 2.1 based
## 0.2.3:
	* updated for CentOS 7.2
	* changed not to use qt-4.tgz, system's instead
## 0.2.4:
	* added gem install for gitlab and github_api
## 0.2.5:
	* handle nodel[:platform] == 'linuxmint'
## 0.2.6:
	* added to install package 'zlib1g-dev' (for linuxmint 18.2)'
## 0.2.7:
	* qtbindings version fixed to 4.8.6.2 (for linuxmint 18.2, ruby 2.2.4p230)
## 0.2.7: 
	* temporarily use /usr/local/anagix_tools/qt-4
## 0.3.0:
 	* dependency on 'build-essential' removed
	* bash gem install replaced w/ gem_package because setting PATH does not work
## 0.3.1:
        * dependency on 'build-essential' revived
## 0.3.2:
	* build-essential removed again because it is now included in chef
        * openssl removed because it is now included in chef
