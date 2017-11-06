# CHANGELOG for alta_env

This file is used to list changes made in each version of alta_env.

## 0.1.0:

* Initial release of alta_env

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.

## 0.1.1:

* Rewrite alta.bat and alta_slave.bat from template
* Use :create_if_missing in remote_file to avoid repetition

## 0.1.2:

* Changed to source gyazowin.exe from 'http://alb.anagix.com:8180/dist/gyazowin.exe'

## 0.1.3:

* windows_zipfile overwrite true set and always overwrite

## 0.1.4:

* alta.conf.erb to use ENV['ProgramFiles'] to read 'Program Files (x86)' on 64bit machines

## 0.1.5:

* put alta files under site_ruby instead of 1.9.1

## 0.1.6:

* raise error unless running on Windows
	
## 0.1.7:
* qtbindings version fixted to 4.8.3.0	
* removed extra c: from alta.conf
* create_if_missing applied to alta.conf

## 0.1.8:
* replaced ENV('HOMEPATH') with File.expand_path('~') which is same as Dir.home after ruby 1.9.3

## 0.1.9:
* version 3.0.0 lock removed from gem install activesupport
	* gem install rubyzip specify version >=1.0.0

## 0.2.0:
	* support chef client 12 which is ruby 2.0.0 based
	* remove files under 1.9.1 only for RUBY_VERSION <= '1.9.3'
	* qtbindings version fix to 4.8.3.0 only when RUBY_VERSION <= '1.9.3'
	* gem install zip-zip and archive-tar-minitar added
## 0.2.1:
	* dependence on windows added in metadata.rb so that it comes from Chef Cookbook, otherwise built-in windows package in recent chef will be used

## 0.2.2:
	* gem install github_api and gitlab added
## 0.2.3:
	* silly bug fix related to above
