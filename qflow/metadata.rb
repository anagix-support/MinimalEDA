name 'qflow'
maintainer 'The Authors'
maintainer_email 'you@example.com'
license 'All Rights Reserved'
description 'Installs/Configures qflow'
long_description 'Installs/Configures qflow'
version '0.1.5'
chef_version '>= 12.1' if respond_to?(:chef_version)

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/qflow/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/qflow'

depends 'qrouter'
depends 'graywolf'
depends 'yosys'
depends 'ngspice'
depends 'irsim'
depends 'dinotrace'
depends 'netgen'
