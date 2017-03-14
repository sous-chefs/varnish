name 'varnish'
maintainer 'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license 'Apache 2.0'
description 'Installs and configures varnish'
version '3.1.0'
source_url 'https://github.com/sous-chefs/varnish'
issues_url 'https://github.com/sous-chefs/varnish/issues'
chef_version '>= 12.5' if respond_to?(:chef_version)

recipe 'varnish', 'Installs and configures varnish'
recipe 'varnish::repo', 'Adds the official varnish project repository'

%w(ubuntu debian redhat amazon centos).each do |os|
  supports os
end

depends 'apt', '>= 2.4', '< 4.1'
depends 'build-essential'
depends 'chef-sugar'
depends 'yum', '>= 3.0', '< 4.1'
depends 'yum-epel'
