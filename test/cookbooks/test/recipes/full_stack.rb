# frozen_string_literal: true

public_html = '/var/www/public_html'

package %w(sudo curl nginx)

directory public_html do
  recursive true
end

file "#{public_html}/index.html" do
  content 'Hello World!'
end

file '/etc/nginx/sites-enabled/default' do
  action :delete
  only_if { ::File.exist?('/etc/nginx/sites-enabled/default') }
end

file '/etc/nginx/conf.d/default.conf' do
  content <<~NGINX
    server {
      listen 8080 default_server;
      listen [::]:8080 default_server;
      root #{public_html};
      index index.html;
    }
  NGINX
  notifies :restart, 'service[nginx]', :immediately
end

service 'nginx' do
  supports restart: true
  action [:enable, :start]
end

varnish 'default' do
  repo_action :nothing
  listen_address '0.0.0.0'
  listen_port 80
  storage 'malloc'
  malloc_percent 33
  log_action :nothing
  ncsa_action :nothing
  action :install
end
