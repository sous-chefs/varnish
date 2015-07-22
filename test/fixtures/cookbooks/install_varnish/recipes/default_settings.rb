include_recipe 'chef-sugar'
include_recipe 'yum-epel' if rhel?
include_recipe 'apt'
package 'curl'

varnish_install 'varnish-install' do
  action :install
end

varnish_default_config 'varnish-config' do
  action :configure
end

varnish_default_vcl 'varnish-vcl' do
  action :configure
end

varnish_log 'varnish-log' do
  action :configure
end
