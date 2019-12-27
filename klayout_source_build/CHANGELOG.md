# klayout CHANGELOG

This file is used to list changes made in each version of the klayout cookbook.

# 0.1.0

Initial release.

# 0.1.1
	timeout 36000 added in bash 'build klayout' block
# 0.1.2
	templace klayout change for /usr/local/bin/klayout:
	LD_LIBRARY_PATH=/opt/chef/embedded/lib:/usr/local/src/klayout/bin-release /usr/local/src/klayout/bin-release/klayout
	
