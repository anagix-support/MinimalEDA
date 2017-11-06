# CHANGELOG for alb_db_bkup

This file is used to list changes made in each version of alb_db_bkup.

## 0.1.0:
	
* Initial release of alb_db_bkup

## 0.1.1:
* fixed not_if not functioning:
   not_if("crontab -l | grep alb_db_bkup") changed to not_if("crontab -l | grep alb_db_bkup", :user => 'anagix')

	- - - 
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.

	
## 0.1.2:
* Dependency fixed	

## 0.1.3:
* dependency on alb_install removed
