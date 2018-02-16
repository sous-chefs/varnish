property :conf_source, String, default: lazy { node['varnish']['conf_source'] }
property :conf_cookbook, String, default: lazy { node['varnish']['conf_cookbook'] }
property :conf_path, String, default: lazy { node['varnish']['conf_path'] }

# Service config options
property :start_on_boot, [TrueClass, FalseClass], default: true
property :max_open_files, Integer, default: 131_072
property :max_locked_memory, Integer, default: 82_000
property :instance_name, String, default: VarnishCookbook::Helpers.hostname
property :major_version, Float, equal_to: [3.0, 4.0, 4.1, 5], default: lazy {
  VarnishCookbook::Helpers.installed_major_version
}

# Daemon options
property :listen_address, String, default: '0.0.0.0'
property :listen_port, Integer, default: 6081
property :path_to_vcl, String, default: '/etc/varnish/default.vcl'
property :admin_listen_address, String, default: '127.0.0.1'
property :admin_listen_port, Integer, default: 6082
property :user, String, default: 'varnish'
property :group, String, default: 'varnish'
property :ccgroup, [String, nil]
property :ttl, Integer, default: 120
property :storage, String, default: 'file', equal_to: %w(file malloc)
property :file_storage_path, String, default: '/var/lib/varnish/%s_storage.bin'
property :file_storage_size, String, default: '1GB'
property :malloc_percent, [Integer, nil], default: 33
property :malloc_size, [String, nil]
property :parameters, Hash, default:
    {
      'thread_pools' => '4',
      'thread_pool_min' => '5',
      'thread_pool_max' => '500',
      'thread_pool_timeout' => '300',
    }
property :path_to_secret, String, default: '/etc/varnish/secret'
property :reload_cmd, String, default: lazy { node['varnish']['reload_cmd'] }

action :configure do
  extend VarnishCookbook::Helpers
  systemd_daemon_reload if node['init_package'] == 'systemd'

  malloc_default = percent_of_total_mem(node['memory']['total'], new_resource.malloc_percent)

  template '/etc/varnish/varnish.params' do
    action :create
    variables(config: new_resource)
    cookbook 'varnish'
    only_if { node['init_package'] == 'systemd' }
  end

  service 'varnish' do
    supports restart: true, reload: true if new_resource.major_version < 5

    # https://github.com/varnishcache/varnish-cache/issues/2316
    supports restart: false, reload: true if new_resource.major_version >= 5

    action :nothing
  end

  # The reload-vcl script doesn't support the -j option in 4.1 and breaks reload on ubuntu.
  # This is fixed upstream but could cause issues if you are using the distro package.
  cookbook_file '/usr/share/varnish/reload-vcl' do
    extend VarnishCookbook::Helpers
    source 'reload-vcl'
    cookbook 'varnish'
    only_if { platform_family?('debian') }
  end

  # This is needed on Ubuntu 16.04 since reload-vcl currently breaks with systemd
  # Should be fixed with https://github.com/varnishcache/pkg-varnish-cache/pull/70
  template '/etc/default/varnish' do
    path '/etc/default/varnish'
    source 'default.erb'
    cookbook 'varnish'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      major_version: new_resource.major_version,
      malloc_size: new_resource.malloc_size || malloc_default,
      config: new_resource
    )
    only_if { node['init_package'] == 'systemd' }
    only_if { node['platform_family'] == 'debian' }
  end

  template new_resource.conf_path do
    path new_resource.conf_path
    source new_resource.conf_source
    cookbook new_resource.conf_cookbook
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      major_version: new_resource.major_version,
      malloc_size: new_resource.malloc_size || malloc_default,
      config: new_resource
    )
    notifies :restart, 'service[varnish]', :delayed
    notifies :run, 'execute[systemctl-daemon-reload]', :immediately if node['init_package'] == 'systemd'
  end
end
