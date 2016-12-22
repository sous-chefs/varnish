provides :varnish_config

default_action :configure

property :name, kind_of: String, name_attribute: true

property :conf_source, kind_of: String, default: lazy { node['varnish']['conf_source'] }
property :conf_cookbook, kind_of: String, default: lazy { node['varnish']['conf_cookbook'] }
property :conf_path, kind_of: String, default: lazy { node['varnish']['conf_path'] }

# Service config options
property :start_on_boot, kind_of: [TrueClass, FalseClass], default: true
property :max_open_files, kind_of: Integer, default: 131_072
property :max_locked_memory, kind_of: Integer, default: 82_000
property :instance_name, kind_of: String, default: node['hostname']
property :major_version, kind_of: Float, equal_to: [3.0, 4.0, 4.1], default: lazy {
  VarnishCookbook::Helpers.installed_major_version
}

# Daemon options
property :listen_address, kind_of: String, default: '0.0.0.0'
property :listen_port, kind_of: Integer, default: 6081
property :path_to_vcl, kind_of: String, default: '/etc/varnish/default.vcl'
property :admin_listen_address, kind_of: String, default: '127.0.0.1'
property :admin_listen_port, kind_of: Integer, default: 6082
property :user, kind_of: String, default: 'varnish'
property :group, kind_of: String, default: 'varnish'
property :ccgroup, kind_of: [String, nil]
property :ttl, kind_of: Integer, default: 120
property :storage, kind_of: String, default: 'file', equal_to: %w(file malloc)
property :file_storage_path, kind_of: String, default: '/var/lib/varnish/%s_storage.bin'
property :file_storage_size, kind_of: String, default: '1GB'
property :malloc_percent, kind_of: [Integer, nil], default: 33
property :malloc_size, kind_of: [String, nil]
property :parameters, kind_of: Hash, default:
    {
      'thread_pools' => '4',
      'thread_pool_min' => '5',
      'thread_pool_max' => '500',
      'thread_pool_timeout' => '300'
    }
property :path_to_secret, kind_of: String, default: '/etc/varnish/secret'
property :reload_cmd, kind_of: String, default: lazy { node['varnish']['reload_cmd'] }

action :configure do
  extend VarnishCookbook::Helpers
  systemd_daemon_reload if node['init_package'] == 'systemd'

  # The reload-vcl script doesn't support the -j option in 4.1 and breaks reload on ubuntu.
  # This is fixed upstream but could cause issues if you are using the distro package.
  cookbook_file '/usr/share/varnish/reload-vcl' do
    extend VarnishCookbook::Helpers
    source 'reload-vcl'
    only_if { platform_family?('debian') }
  end

  malloc_default = percent_of_total_mem(node['memory']['total'], new_resource.malloc_percent)

  service 'varnish' do
    supports restart: true, reload: true
    action :nothing
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
      malloc_size: malloc_size || malloc_default,
      config: new_resource
    )
    notifies :restart, 'service[varnish]', :delayed
    notifies :run, 'execute[systemctl-daemon-reload]', :immediately if node['init_package'] == 'systemd'
  end
end
