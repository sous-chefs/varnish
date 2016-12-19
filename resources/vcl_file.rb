provides :vcl_file

default_action :configure

property :vcl_name, kind_of: String, name_attribute: true
property :source, kind_of: String, default: lazy { ::File.basename(vcl_name) }
property :cookbook, kind_of: String
property :owner, kind_of: String, default: 'root'
property :group, kind_of: String, default: 'root'
property :mode, kind_of: String, default: '0644'
property :varnish_dir, kind_of: String, default: '/etc/varnish'
property :vcl_path, kind_of: String, default: lazy { ::File.join(varnish_dir, vcl_name) }

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
