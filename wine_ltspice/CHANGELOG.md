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
## 0.3.1:
* Wine install for CentOS and RHEL revised:
   CentOS6 to use 'yum install epel-release', RHEL to use old scheme (not tested)
	CentOS7 to use Anagix built rpm for i686 (because epel wine for CentOS fails to install both LTspiceIV.exe and LTspiceXII.exe)
## 0.3.2
*winehp key changed:
	* wget -nc https://dl.winehq.org/wine-builds/winehq.key
## 0.3.3
## 0.3.4
	* LTspiceIV changed to LTspiceXVII
