# frozen_string_literal: true

name 'varnish'
maintainer 'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license 'Apache-2.0'
description 'Installs and configures varnish'
version '4.1.0'

source_url 'https://github.com/sous-chefs/varnish'
issues_url 'https://github.com/sous-chefs/varnish/issues'
chef_version '>= 14'

supports 'ubuntu'
supports 'debian'
supports 'redhat'
supports 'amazon'
supports 'centos'

depends 'yum-epel'
