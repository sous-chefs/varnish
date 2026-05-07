# frozen_string_literal: true

provides :varnish_repo, platform_family: 'debian'
unified_mode true

property :major_version, Float, default: 6.0
property :fetch_gpg_key, [true, false], default: true

default_action :configure

action :configure do
  # packagecloud repos omit dot from major version
  major_version_no_dot = new_resource.major_version.to_s.tr('.', '')

  apt_preference 'varnish' do
    glob '*'
    pin "release l=varnish#{major_version_no_dot}"
    pin_priority '1000'
  end

  apt_repository "varnish-cache_#{new_resource.major_version}" do
    uri "https://packagecloud.io/varnishcache/varnish#{major_version_no_dot}/#{node['platform']}/"
    components ['main']
    key "https://packagecloud.io/varnishcache/varnish#{major_version_no_dot}/gpgkey" if new_resource.fetch_gpg_key
    deb_src true
    action :add
  end
end

action :unconfigure do
  major_version_no_dot = new_resource.major_version.to_s.tr('.', '')

  apt_preference 'varnish' do
    action :remove
  end

  apt_repository "varnish-cache_#{new_resource.major_version}" do
    uri "https://packagecloud.io/varnishcache/varnish#{major_version_no_dot}/#{node['platform']}/"
    action :remove
  end
end
