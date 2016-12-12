provides :varnish_log

property :name, kind_of: String, name_attribute: true
property :file_name, kind_of: String, default: '/var/log/varnish/varnishlog.log'
property :logrotate, kind_of: [TrueClass, FalseClass], default: true
property :logrotate_path, kind_of: String, default: '/etc/logrotate.d'
property :pid, kind_of: String, default: '/var/run/varnishlog.pid'
property :log_format, kind_of: String, default: 'varnishlog', equal_to: ['varnishlog', 'varnishncsa']
property :ncsa_format_string, kind_of: String, default: '%h|%l|%u|%t|\"%r\"|%s|%b|\"%{Referer}i\"|\"%{User-agent}i\"'
property :major_version, kind_of: Float, equal_to: [3.0, 4.0, 4.1]
property :instance_name, kind_of: String, default: nil

action :configure do
  version = new_resource.major_version || VarnishCookbook::Helpers.installed_major_version

  service new_resource.log_format do
    action :nothing
  end

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
  end

  template "/etc/default/#{new_resource.log_format}" do
    if node['init_package'] == 'init'
      path "/etc/default/#{new_resource.log_format}"
      source 'varnishlog.erb'
    elsif node['init_package'] == 'systemd'
      path "/etc/systemd/system/#{new_resource.log_format}.service"
      source 'varnishlog_systemd.erb'
    else
      path "/etc/sysconfig/#{new_resource.log_format}"
      source 'varnishlog.erb'
    end
    cookbook 'varnish'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      config: new_resource,
      major_version: version
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
