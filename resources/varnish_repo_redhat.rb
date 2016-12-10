provides :varnish_repo, platform_family: ['rhel', 'fedora']

property :major_version, kind_of: Float, equal_to: [3.0, 4.0, 4.1], default: lazy { node['varnish']['major_version'] }
property :fetch_gpg_key, kind_of: [TrueClass, FalseClass], default: true

action :configure do
  yum_repository "varnish-cache_#{new_resource.major_version}" do
    description "Varnish #{new_resource.major_version} repo (#{node['platform_version']} - $basearch)"
    url "http://repo.varnish-cache.org/redhat/varnish-#{new_resource.major_version}/el#{node['platform_version'].to_i}/"
    gpgcheck true
    gpgkey 'https://repo.varnish-cache.org/debian/GPG-key.txt' if new_resource.fetch_gpg_key
    action :create
  end
end
