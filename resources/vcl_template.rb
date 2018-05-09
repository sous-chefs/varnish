provides :vcl_template

property :vcl_name, String, name_property: true
property :source, String, default: lazy { "#{::File.basename(vcl_name)}.erb" }
property :cookbook, String
property :owner, String, default: 'root'
property :group, String, default: 'root'
property :mode, String, default: '0644'
property :variables, Hash, default: {}
property :varnish_dir, String, default: '/etc/varnish'
property :vcl_path, String, default: lazy { ::File.join(varnish_dir, vcl_name) }

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
        installed_version: installed_version,
      },
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
