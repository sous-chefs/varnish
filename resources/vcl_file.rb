provides :vcl_file

property :vcl_name, String, name_property: true
property :source, String, default: lazy { ::File.basename(vcl_name) }
property :cookbook, String
property :owner, String, default: 'root'
property :group, String, default: 'root'
property :mode, String, default: '0644'
property :varnish_dir, String, default: '/etc/varnish'
property :vcl_path, String, default: lazy { ::File.join(varnish_dir, vcl_name) }

action :configure do
  service 'varnish' do
    supports restart: true, reload: true
    action :nothing
  end

  cookbook_file new_resource.vcl_path do
    source new_resource.source
    cookbook new_resource.cookbook if new_resource.cookbook
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
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
