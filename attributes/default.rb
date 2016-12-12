if platform_family?('debian')
  default['varnish']['conf_path'] = '/etc/default/varnish'
  default['varnish']['reload_cmd'] = '/usr/share/varnish/reload-vcl'
else
  default['varnish']['conf_path'] = '/etc/sysconfig/varnish'
  default['varnish']['reload_cmd'] = '/usr/sbin/varnish_reload_vcl'
end

if node['init_package'] == 'init'
  default['varnish']['conf_source'] = 'default.erb'
elsif node['init_package'] == 'systemd'
  # Ubuntu >= 15.04, Debian >= 8, CentOS >= 7
  default['varnish']['conf_source'] = 'default_systemd.erb'
  default['varnish']['conf_path'] = '/etc/systemd/system/varnish.service'
else
  default['varnish']['conf_source'] = 'default.erb'
end
