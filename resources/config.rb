property :conf_source, String, default: lazy { node['varnish']['conf_source'] }
property :conf_cookbook, String, default: lazy { node['varnish']['conf_cookbook'] }
property :conf_path, String, default: lazy { node['varnish']['conf_path'] }

# Service config options
property :start_on_boot, [true, false],
          default: true,
          deprecated: 'This property has been deprecated and will be removed in a future release'
property :max_open_files, Integer, default: 131_072
property :max_locked_memory, Integer, default: 82_000
property :instance_name, String, default: VarnishCookbook::Helpers.hostname
property :major_version, Float,
          equal_to: VarnishCookbook::Helpers.supported_major_versions,
          default: lazy { VarnishCookbook::Helpers.installed_major_version }

# Daemon options
property :listen_address, String, default: '0.0.0.0'
property :listen_port, Integer, default: 6081
property :secondary_listen_address, [String, nil]
property :secondary_listen_port, [Integer, nil]
property :path_to_vcl, String, default: '/etc/varnish/default.vcl'
property :admin_listen_address, String, default: '127.0.0.1'
property :admin_listen_port, Integer, default: 6082
property :user, String,
          default: 'varnish',
          deprecated: 'This property has been deprecated and will be removed in a future release'
property :group, String,
          default: 'varnish',
          deprecated: 'This property has been deprecated and will be removed in a future release'
property :ccgroup, [String, nil],
          deprecated: 'This property has been deprecated and will be removed in a future release'
property :ttl, Integer,
          default: 120,
          deprecated: 'This property has been deprecated and will be removed in a future release'
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

unified_mode true

action :configure do
  extend VarnishCookbook::Helpers
  systemd_daemon_reload

  malloc_default = percent_of_total_mem(node['memory']['total'], new_resource.malloc_percent)

  template '/etc/varnish/varnish.params' do
    action :create
    variables(
      major_version: new_resource.major_version,
      malloc_size: new_resource.malloc_size || malloc_default,
      config: new_resource
    )
    cookbook 'varnish'
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
    mode '0755'
    only_if { platform_family?('debian') }
  end

  execute 'generate secret file' do
    command "dd if=/dev/random of=#{new_resource.path_to_secret} count=1"
    creates new_resource.path_to_secret
    only_if { new_resource.major_version >= 6.1 }
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
    notifies :run, 'execute[systemctl-daemon-reload]', :immediately
  end
end
