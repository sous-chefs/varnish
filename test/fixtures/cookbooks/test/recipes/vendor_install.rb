# frozen_string_literal: true

# include_recipe 'yum-epel'
# include_recipe "#{cookbook_name}::_nginx"

varnish_install 'configure'

varnish_config 'default'

vcl_template 'default.vcl' do
  backend_port '80'
  backend_host '127.0.0.1'
end

service 'varnish'

varnish_log 'default'

varnish_log 'default_ncsa' do
  log_format 'varnishncsa'
end
