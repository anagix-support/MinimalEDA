name 'alta_env_linux'
maintainer       "Anagix Corp."
maintainer_email "seijiro.moriyama@anagix.com"
license          "All rights reserved"
description      "Installs/Configures alta_env_linux"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.8"
# depends 'build-essential'
depends 'wine_ltspice'
# depends 'anagix_init' ==> wine_ltspice depends on anagix_init
depends 'anagix_init' # revived
depends 'openssl'
