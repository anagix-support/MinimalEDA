name 'alta_env_linux'
maintainer       "Anagix Corp."
maintainer_email "seijiro.moriyama@anagix.com"
license          "All rights reserved"
description      "Installs/Configures alta_env_linux"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.3.4"
#depends 'build-essential'
depends 'wine_ltspice' unless File.exist?('/proc/version') && `grep -E "(MicroSoft|Microsoft|WSL)" /proc/version` != ''
# depends 'anagix_init' ==> wine_ltspice depends on anagix_init
depends 'anagix_init' # revived
#depends 'openssl'
