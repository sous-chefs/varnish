# frozen_string_literal: true

apt_update 'full_stack'

include_recipe 'varnish::default'

# Set up nginx first since it likes to start listening on port 80 during install
package 'varnish'

service 'varnish' do
  action %i(enable start)
end

varnish_config 'default' do
  listen_address '0.0.0.0'
  listen_port 80
  storage 'malloc'
  malloc_percent 33
end

vcl_template 'default.vcl' do
  source 'default.vcl.erb'
  variables(
    config: {
      backend_host: '127.0.0.1',
      backend_port: '8080',
    }
  )
end
