name 'varnish'
maintainer 'Opscode, Inc.'
maintainer_email 'cookbooks@opscode.com'
license 'Apache 2.0'
description 'Installs and configures varnish'
version '0.9.18'

recipe 'varnish', 'Installs and configures varnish'
recipe 'varnish::repo', 'Adds the official varnish project repository'

%w(ubuntu debian redhat amazon centos).each do |os|
  supports os
end

depends 'apt', '~> 2.4'
depends 'build-essential'
depends 'yum', '~> 3.0'
depends 'yum-epel'
