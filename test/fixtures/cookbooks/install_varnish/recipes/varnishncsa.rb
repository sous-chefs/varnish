package 'varnish'

service 'varnish' do
  action [:enable, :start]
end

# needed for tests because this directory is not always on created instances
directory 'logrotate' do
  path '/etc/logrotate.d'
  user 'root'
  group 'root'
  mode '0755'
  action :create
end

varnish_default_config 'default'

# varnishncsa
varnish_log 'default_ncsa' do
  file_name '/var/log/varnish/varnishncsa.log'
  pid '/var/run/varnishncsa.pid'
  log_format 'varnishncsa'
  ncsa_format_string '%h|%l|%u|%t|\"%r\"|%s|%b|\"%{Referer}i\"|\"%{User-agent}i\"'
  logrotate false
end
