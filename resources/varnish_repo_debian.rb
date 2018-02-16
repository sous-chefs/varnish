provides :varnish_repo, platform_family: 'debian'

property :major_version, Float, equal_to: [2.1, 3.0, 4.0, 4.1, 5], default: lazy { node['varnish']['major_version'] }
property :fetch_gpg_key, [TrueClass, FalseClass], default: true

action :configure do
  # packagecloud repos omit dot from major version
  major_version_no_dot = new_resource.major_version.to_s.tr('.', '')
  apt_repository "varnish-cache_#{new_resource.major_version}" do
    uri "https://packagecloud.io/varnishcache/varnish#{major_version_no_dot}/#{node['platform']}/"
    distribution node['lsb']['codename']
    components ['main']
    key "https://packagecloud.io/varnishcache/varnish#{major_version_no_dot}/gpgkey" if new_resource.fetch_gpg_key
    deb_src true
    action :add
  end
end
