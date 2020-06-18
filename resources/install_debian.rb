# frozen_string_literal: true

property :version, Float, default: 6.4
property :fetch_gpg_key, [true, false], default: false

action :configure do
  # packagecloud repos omit dot from major version
  major_version_no_dot = new_resource.version.to_s.tr('.', '')

  apt_repository "varnish-cache_#{new_resource.major_version}" do
    uri "https://packagecloud.io/varnishcache/varnish#{major_version_no_dot}/#{node['platform']}/"
    components ['main']
    key "https://packagecloud.io/varnishcache/varnish#{major_version_no_dot}/gpgkey" if new_resource.fetch_gpg_key
    deb_src true
    action :add
  end
end
