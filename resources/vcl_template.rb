provides :vcl_template

default_action :configure

property :vcl_name, kind_of: String, name_attribute: true
property :source, kind_of: String, default: lazy { "#{::File.basename(vcl_name)}.erb" }
property :cookbook, kind_of: String
property :owner, kind_of: String, default: 'root'
property :group, kind_of: String, default: 'root'
property :mode, kind_of: String, default: '0644'
property :variables, kind_of: Hash, default: {}
property :varnish_dir, kind_of: String, default: '/etc/varnish'
property :vcl_path, kind_of: String, default: lazy { ::File.join(varnish_dir, vcl_name) }

action :configure do
  extend VarnishCookbook::Helpers
  service 'varnish' do
    supports restart: true, reload: true
    action :nothing
  end

  begin
    installed_version = VarnishCookbook::Helpers.installed_major_version
  rescue
    installed_version = nil
    Chef::Log.warn 'varnish version will not be available in vcl_template variables.'
  end

  var_hash = new_resource.variables
  merged_var_hash = Chef::Mixin::DeepMerge.deep_merge(
    {
      varnish: {
        installed_version: installed_version
      }
    }, var_hash
  )

  template new_resource.vcl_path do
    source new_resource.source
    cookbook new_resource.cookbook if new_resource.cookbook
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
    variables merged_var_hash
    notifies :reload, 'service[varnish]', :delayed
  end
end

action :unconfigure do
  service 'varnish' do
    supports restart: true, reload: true
    action :nothing
  end

  file new_resource.vcl_path do
    notifies :reload, 'service[varnish]', :delayed
  end
end
