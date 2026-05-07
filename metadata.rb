# frozen_string_literal: true

name              'varnish'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Installs and configures varnish'
version           '6.0.0'
source_url        'https://github.com/sous-chefs/varnish'
issues_url        'https://github.com/sous-chefs/varnish/issues'
chef_version      '>= 15.3'

supports 'almalinux', '>= 8.0'
supports 'centos_stream', '>= 9.0'
supports 'debian', '>= 12.0'
supports 'oracle', '>= 8.0'
supports 'redhat', '>= 8.0'
supports 'rocky', '>= 8.0'
supports 'ubuntu', '>= 22.04'

depends 'yum', '>= 7.2'
depends 'yum-epel'
