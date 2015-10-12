include_recipe 'apt'
package 'curl'

varnish_install 'default' do
  package_name 'varnish'
  vendor_repo true
  vendor_version '4.0'
end

# needed for tests because this directory is not always on created instances
directory 'logrotate' do
  path '/etc/logrotate.d'
  user 'root'
  group 'root'
  mode '0755'
  action :create
end

varnish_default_config 'default' do
  start_on_boot true
  max_open_files 131_072
  max_locked_memory 82_000
  listen_address nil
  listen_port 6081
  path_to_vcl '/etc/varnish/default.vcl'
  admin_listen_address '127.0.0.1'
  admin_listen_port 6082
  user 'varnish'
  group 'varnish'
  ttl 120
  storage 'malloc'
  malloc_size "#{(node['memory']['total'][0..-3].to_i * 0.75).to_i}K"
  parameters(thread_pools: '4',
             thread_pool_min: '5',
             thread_pool_max: '500',
             thread_pool_timeout: '300')
  path_to_secret '/etc/varnish/secret'
end

varnish_default_vcl 'default' do
  backend_host 'rackspace.com'
  backend_port 80
end

varnish_log 'default' do
  file_name '/var/log/varnish/varnishlog.log'
  pid '/var/run/varnishlog.pid'
  log_format 'varnishlog'
  logrotate false
end

varnish_log 'default_ncsa' do
  file_name '/var/log/varnish/varnishncsa.log'
  pid '/var/run/varnishncsa.pid'
  log_format 'varnishncsa'
  ncsa_format_string '%h|%l|%u|%t|\"%r\"|%s|%b|\"%{Referer}i\"|\"%{User-agent}i\"'
  logrotate true
  logrotate_path '/etc/logrotate.d'
end
