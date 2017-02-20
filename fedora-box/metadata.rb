name             'fedora-box'
maintainer       'Kevin Ford'
maintainer_email 'kford1@artic.edu'
description      'Configures Fedora Box'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.1'

depends          'java'

depends          'database'
depends          'postgresql'

depends          'tomcat'