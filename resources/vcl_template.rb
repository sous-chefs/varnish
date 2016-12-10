provides :vcl_template

default_action :configure

property :vcl_name, kind_of: String, name_attribute: true
property :source, kind_of: String, required: true
property :cookbook, kind_of: String
property :owner, kind_of: String, default: 'root'
property :group, kind_of: String, default: 'root'
property :mode, kind_of: String, default: '0644'
property :variables, kind_of: Hash, default: {}
property :varnish_dir, kind_of: String, default: '/etc/varnish'

action :configure do
  service 'varnish' do
    supports restart: true, reload: true
    action :nothing
  end

  template ::File.join(new_resource.varnish_dir, new_resource.vcl_name + '.vcl') do
    source new_resource.source
    cookbook new_resource.cookbook if new_resource.cookbook
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
    variables new_resource.variables
    notifies :reload, 'service[varnish]', :delayed
  end
end
