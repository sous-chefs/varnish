if platform_family?('debian')
  default['varnish']['default'] = '/etc/default/varnish'
else
  default['varnish']['default'] = '/etc/sysconfig/varnish'
end

default['varnish']['version'] = '4.0'

default['varnish']['dir'] = '/etc/varnish'
default['varnish']['start'] = 'yes'
default['varnish']['nfiles'] = 131_072
default['varnish']['memlock'] = 82_000
default['varnish']['instance'] = node['fqdn']
default['varnish']['listen_address'] = nil
default['varnish']['listen_port'] = 6081
default['varnish']['vcl_conf'] = 'default.vcl'
default['varnish']['vcl_source'] = 'default.vcl.erb'
default['varnish']['vcl_cookbook'] = 'varnish'
default['varnish']['vcl_generated'] = true
default['varnish']['conf_source'] = 'default.erb'
default['varnish']['conf_cookbook'] = 'varnish'
default['varnish']['secret_file'] = '/etc/varnish/secret'
default['varnish']['admin_listen_address'] = '127.0.0.1'
default['varnish']['admin_listen_port'] = '6082'
default['varnish']['user'] = 'varnish'
default['varnish']['group'] = 'varnish'
default['varnish']['ttl'] = '120'
default['varnish']['parameters']['thread_pools'] = '4'
default['varnish']['parameters']['thread_pool_min'] = '5'
default['varnish']['parameters']['thread_pool_max'] = '500'
default['varnish']['parameters']['thread_pool_timeout'] = '300'
default['varnish']['storage'] = 'file'
default['varnish']['storage_file'] = '/var/lib/varnish/$INSTANCE_varnish_storage.bin'
default['varnish']['storage_size'] = '1G'
default['varnish']['log_daemon'] = true
default['varnish']['use_default_repo'] = true

default['varnish']['backend_host'] = 'localhost'
default['varnish']['backend_port'] = '8080'
