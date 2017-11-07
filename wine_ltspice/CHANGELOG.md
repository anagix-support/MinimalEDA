# CHANGELOG for wine_ltspice
	
This file is used to list changes made in each version of wine_ltspice.

## 0.1.0:
* Initial release of wine_ltspice

## 0.1.1:
* package xauth and x11-apps added	
	
## 0.1.3:
* install_ltspice revised	

## 0.1.8:
*  revised for CentOS 7 which needs home brew wine(for 32bit Windows app)
## 0.1.9:
* bug fix: targets = ['xauth', 'x11apps', 'imagemagick'] -> targets = ['xauth', x11apps, imagemagick]	
## 0.2.0:
* do not install wine if wine has been installed manually (Ubuntu 16.04 fails to apt-get install)
* templates/default/install_ltspice restored (has been lost even in Anagix Chef server)
## 0.3.0:
* Follow Wine instruction from WineHQ for Ubuntu: https://wiki.winehq.org/Ubuntu
