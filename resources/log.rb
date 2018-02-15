property :file_name, String, default: lazy { "/var/log/varnish/#{log_format}.log" }
property :pid, String, default: lazy { "/var/run/#{log_format}.pid" }
property :log_format, String, default: 'varnishlog', equal_to: %w(varnishlog varnishncsa)
property :logrotate, [TrueClass, FalseClass], default: lazy { log_format == 'varnishlog' }
property :logrotate_path, String, default: '/etc/logrotate.d'
property :instance_name, String, default: VarnishCookbook::Helpers.hostname

property :major_version, Float, equal_to: [3.0, 4.0, 4.1], default: lazy {
  VarnishCookbook::Helpers.installed_major_version
}

property :ncsa_format_string, [String, nil], default: lazy {
  if log_format == 'varnishncsa' && major_version > 2.0
    '%h|%l|%u|%t|\"%r\"|%s|%b|\"%{Referer}i\"|\"%{User-agent}i\"'
  end
}

action :configure do
  extend VarnishCookbook::Helpers
  systemd_daemon_reload if node['init_package'] == 'systemd'

  # The varnishlog group was removed from some of the more recent varnish packages.
  group 'varnishlog' do
    system true
  end

  # If the package includes a systemd init script we don't want it taking precedence over ours
  file "/lib/systemd/system/#{new_resource.log_format}.service" do
    action :delete
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

  link "/etc/sysconfig/#{new_resource.log_format}" do
    to "/etc/default/#{new_resource.log_format}"
    only_if { node['init_package'] == 'init' }
    only_if { node['platform_family'] == 'rhel' }
  end

  template "init_#{new_resource.log_format}" do
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
    notifies :run, 'execute[systemctl-daemon-reload]', :immediately if node['init_package'] == 'systemd'
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
