name 'varnish'
maintainer 'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license 'Apache-2.0'
description 'Installs and configures varnish'
version '4.0.1'

source_url 'https://github.com/sous-chefs/varnish'
issues_url 'https://github.com/sous-chefs/varnish/issues'
chef_version '>= 12.15'

%w(ubuntu debian redhat amazon centos).each do |os|
  supports os
end

depends 'chef-sugar'
depends 'yum-epel'
