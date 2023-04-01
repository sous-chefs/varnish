name              'varnish'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Installs and configures varnish'
version           '5.0.10'
source_url        'https://github.com/sous-chefs/varnish'
issues_url        'https://github.com/sous-chefs/varnish/issues'
chef_version      '>= 15.5'

supports 'amazon'
supports 'centos'
supports 'debian'
supports 'redhat'
supports 'ubuntu'

depends 'yum', '>= 7.2'
depends 'yum-epel'
