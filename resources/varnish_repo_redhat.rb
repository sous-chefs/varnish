provides :varnish_repo, platform_family: ['rhel', 'fedora']

property :major_version, Float, equal_to: [2.1, 3.0, 4.0, 4.1, 5], default: lazy { node['varnish']['major_version'] }

action :configure do
  # packagecloud repos omit dot from major version
  major_version_no_dot = new_resource.major_version.to_s.tr('.', '')
  yum_repository "varnish-cache_#{new_resource.major_version}" do
    description "Varnish #{new_resource.major_version} repo (#{node['platform_version']} - $basearch)"
    url "https://packagecloud.io/varnishcache/varnish#{major_version_no_dot}/el/#{node['platform_version'].to_i}/$basearch"
    gpgcheck false
    repo_gpgcheck true
    gpgkey "https://packagecloud.io/varnishcache/varnish#{major_version_no_dot}/gpgkey"
    action :create
  end
end
