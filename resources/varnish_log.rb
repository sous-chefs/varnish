provides :varnish_log

default_action :configure

property :name, kind_of: String, name_attribute: true
property :file_name, kind_of: String, default: '/var/log/varnish/varnishlog.log'
property :pid, kind_of: String, default: '/var/run/varnishlog.pid'
property :log_format, kind_of: String, default: 'varnishlog', equal_to: %w(varnishlog varnishncsa)
property :logrotate, kind_of: [TrueClass, FalseClass], default: lazy { log_format == 'varnishlog' }
property :logrotate_path, kind_of: String, default: '/etc/logrotate.d'
property :instance_name, kind_of: String, default: VarnishCookbook::Helpers.hostname

property :major_version, kind_of: Float, equal_to: [3.0, 4.0, 4.1], default: lazy {
  VarnishCookbook::Helpers.installed_major_version
}

property :ncsa_format_string, kind_of: [String, nil], default: lazy {
  if log_format == 'varnishncsa' && major_version > 2.0
    '%h|%l|%u|%t|\"%r\"|%s|%b|\"%{Referer}i\"|\"%{User-agent}i\"'
  end
}

action :configure do
  # The varnishlog group was removed from some of the more recent varnish packages.
  group 'varnishlog' do
    system true
  end

  cookbook_file '/etc/init.d/varnishlog' do
    source "varnishlog_initd_#{node['platform_family']}"
    cookbook 'varnish'
    owner 'root'
    group 'root'
    mode '0755'
    only_if { node['init_package'] == 'init' }
    only_if { new_resource.log_format == 'varnishlog' }
  end

  template "/etc/default/#{new_resource.log_format}" do
    path template_path(new_resource.log_format)
    source template_source
    cookbook 'varnish'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      config: new_resource
    )
    action :create
    notifies :restart, "service[#{new_resource.log_format}]", :delayed
  end

  template "#{new_resource.logrotate_path}/#{new_resource.log_format}" do
    source 'logrotate_varnishlog.erb'
    path "#{new_resource.logrotate_path}/#{new_resource.log_format}"
    cookbook 'varnish'
    owner 'root'
    group 'root'
    mode '0644'
    variables(config: new_resource)
    action :create
    only_if { new_resource.logrotate && ::File.exist?(new_resource.logrotate_path) }
  end

  service new_resource.log_format do
    supports restart: true, reload: true
    action %w(enable start)
  end
end

def template_path(log_format)
  if node['init_package'] == 'init'
    "/etc/default/#{log_format}"
  elsif node['init_package'] == 'systemd'
    "/etc/systemd/system/#{log_format}.service"
  else
    "/etc/sysconfig/#{log_format}"
  end
end

def template_source
  if node['init_package'] == 'init'
    'varnishlog.erb'
  elsif node['init_package'] == 'systemd'
    'varnishlog_systemd.erb'
  else
    'varnishlog.erb'
  end
end
