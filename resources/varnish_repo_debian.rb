provides :varnish_repo, platform_family: 'debian'

default_action :create

properties :major_version, kind_of: String, is: %w(3.0 4.0 4.1), default: lazy { node['varnish']['major_version'] }
properties :fetch_gpg_key, kind_of: [TrueClass, FalseClass], default: true

action :create do
  apt_repository "varnish-cache_#{new_resource.major_version}" do
    uri "http://repo.varnish-cache.org/#{node['platform']}"
    distribution node['lsb']['codename']
    components ["varnish-#{new_resource.vendor_version}"]
    key "https://repo.varnish-cache.org/#{node['platform']}/GPG-key.txt" if new_resource.fetch_gpg_key
    deb_src true
  end
end
