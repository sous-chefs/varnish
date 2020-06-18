provides :vcl_template

property :vcl_name, String, name_property: true
property :source, String, default: lazy { "#{::File.basename(vcl_name)}.erb" }
property :cookbook, String, default: 'varnish'
property :owner, String, default: 'root'
property :group, String, default: 'root'
property :mode, String, default: '0644'
property :backend_host, String, required: true
property :backend_port, String, required: true
property :varnish_dir, String, default: '/etc/varnish'
property :vcl_path, String, default: lazy { ::File.join(varnish_dir, vcl_name) }

action :configure do
  extend VarnishCookbook::Helpers
  service 'varnish' do
    supports restart: true, reload: true
    action :nothing
  end

  template new_resource.vcl_path do
    source new_resource.source
    cookbook new_resource.cookbook if new_resource.cookbook
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
    variables(
      backend_host: new_resource.backend_host,
      backend_port: new_resource.backend_port
    )
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
