# frozen_string_literal: true

property :version, Float, default: 6.4
property :fetch_gpg_key, [true, false], default: true

action :configure do
  # packagecloud repos omit dot from major version
  version_no_dot = new_resource.version.to_s.tr('.', '')

  packages = %w(curl apt-transport-https)
  packages << 'debian-archive-keyring' if platform?('debian')
  package packages

  packagecloud_repo "varnishcache/varnish#{version_no_dot}" do
    type 'deb'
  end

  # apt_repository "varnish-cache_#{new_resource.version}" do
  #   uri "https://packagecloud.io/varnishcache/varnish#{version_no_dot}/#{node['platform']}/"
  #   components ['main']
  #   key "https://packagecloud.io/varnishcache/varnish#{version_no_dot}/gpgkey" if new_resource.fetch_gpg_key
  #   keyserver 'packagecloud.io'
  #   deb_src true
  #   action :add
  # end

  package 'varnish'
end
