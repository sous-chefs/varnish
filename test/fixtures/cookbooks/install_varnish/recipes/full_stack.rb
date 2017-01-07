node.override['varnish']['configure']['config']['listen_port'] = 80
node.override['varnish']['configure']['repo']['action'] = :nothing
node.override['varnish']['configure']['ncsa']['action'] = :configure

package 'nginx'

service 'nginx' do
  action :nothing
end

cookbook_file '/etc/nginx/sites-enabled/default' do
  notifies_immediately :restart, 'service[nginx]'
end

directory '/var/www/public_html' do
  recursive true
end

file '/var/www/public_html/index.html' do
  content 'Hello World!'
end

include_recipe 'varnish::configure'
