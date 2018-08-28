name 'varnish'
maintainer 'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license 'Apache-2.0'
description 'Installs and configures varnish'
version '4.0.0'

source_url 'https://github.com/sous-chefs/varnish'
issues_url 'https://github.com/sous-chefs/varnish/issues'
chef_version '>= 12.15'

recipe 'varnish', 'Installs and configures varnish'
recipe 'varnish::repo', 'Adds the official varnish project repository'

%w(ubuntu debian redhat amazon centos).each do |os|
  supports os
end

depends 'chef-sugar'
depends 'yum-epel'
