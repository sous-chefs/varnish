provides :varnish_repo, platform_family: ['rhel', 'fedora']

default_action :configure

property :major_version, kind_of: Float, equal_to: [2.1, 3.0, 4.0, 4.1], default: lazy { node['varnish']['major_version'] }

action :configure do
  yum_repository "varnish-cache_#{new_resource.major_version}" do
    description "Varnish #{new_resource.major_version} repo (#{node['platform_version']} - $basearch)"
    url "http://repo.varnish-cache.org/redhat/varnish-#{new_resource.major_version}/el#{node['platform_version'].to_i}/"
    gpgcheck false
    action :create
  end
end
