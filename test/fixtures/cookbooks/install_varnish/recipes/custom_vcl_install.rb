include_recipe 'apt'
package 'curl'

varnish_install 'default' do
  package_name 'varnish'
  vendor_repo true
  vendor_version '4.0'
end

varnish_default_config 'default'

varnish_default_vcl 'default' do
  vcl_source 'lib_default_custom.vcl.erb'
  vcl_cookbook 'install_varnish'
  vcl_parameters(url: '/test_url')
end
