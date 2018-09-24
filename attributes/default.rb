##
## Resource settings
##

default['varnish']['conf_cookbook'] = 'varnish'
default['varnish']['major_version'] = 4.1

default['varnish']['configure']['repo']['action'] = :configure

# Prevent installation of distro varnish on RHEL/CentOS
default['yum']['epel']['exclude'] = 'varnish' unless node['varnish']['configure']['repo']['action'].to_sym == :nothing

if platform_family?('debian')
  default['varnish']['conf_path'] = '/etc/default/varnish'
  # Install specific version of Varnish on Debian/Ubuntu
  default['varnish']['configure']['package']['version'] = "#{node['varnish']['major_version']}.\*" unless node['varnish']['configure']['repo']['action'].to_sym == :nothing
else
  default['varnish']['conf_path'] = '/etc/sysconfig/varnish'
end

default['varnish']['reload_cmd'] = if node['varnish']['major_version'] >= 6.1
                                     '/usr/sbin/varnishreload'
                                   elsif node['varnish']['major_version'] < 4
                                     '/usr/bin/varnish_reload_vcl'
                                   elsif platform_family?('debian')
                                     '/usr/share/varnish/reload-vcl'
                                   else
                                     '/usr/sbin/varnish_reload_vcl'
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

## varnish::configure recipe settings
##
## This recipe uses namespaced attributes to configure resources.
##
## Resource                   | Attribute Namespace
## ---------------------------|------------------------
## varnish_repo   'configure' | node['varnish']['configure']['repo']
## package        'varnish'   | node['varnish']['configure']['package']
## service        'varnish'   | node['varnish']['configure']['service']
## varnish_config 'default'   | node['varnish']['configure']['config']
## vcl_template   'default'   | node['varnish']['configure']['vcl_template']
## varnish_log    'default'   | node['varnish']['configure']['log']
## varnish_log    'ncsa'      | node['varnish']['configure']['ncsa']
##

# Disable vendor repo:
# override['varnish']['configure']['repo']['action'] = :nothing

# Install specific varnish version:
# override['varnish']['configure']['package']['version'] = '4.1.1-1~trusty'

# Disable logs:
# override['varnish']['configure']['log']['action'] = :nothing

default['varnish']['configure']['package']['action'] = :install

default['varnish']['configure']['service']['action'] = [:start, :enable]

default['varnish']['configure']['config']['action'] = :configure

default['varnish']['configure']['vcl_template']['source']    = 'default.vcl.erb'
default['varnish']['configure']['vcl_template']['variables'] = {
  config: {
    backend_host: '127.0.0.1',
    backend_port: '8080',
  },
}

default['varnish']['configure']['log'] = {}

default['varnish']['configure']['ncsa']['action'] = :nothing
