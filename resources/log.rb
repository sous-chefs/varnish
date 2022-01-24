# frozen_string_literal: true

property :file_name, String, default: lazy { "/var/log/varnish/#{log_format}.log" }
property :pid, String, default: lazy { "/var/run/#{log_format}.pid" }
property :log_format, String, default: 'varnishlog', equal_to: %w(varnishlog varnishncsa)
property :logrotate, [true, false], default: lazy { log_format == 'varnishlog' }
property :logrotate_path, String, default: '/etc/logrotate.d'
property :instance_name, String, default: VarnishCookbook::Helpers.hostname

property :ncsa_format_string, [String, nil], default: lazy {
  '%h|%l|%u|%t|\"%r\"|%s|%b|\"%{Referer}i\"|\"%{User-agent}i\"' if log_format == 'varnishncsa'
}

action :configure do
  extend VarnishCookbook::Helpers
  systemd_daemon_reload

  # The varnishlog group was removed from some of the more recent varnish packages.
  group 'varnishlog' do
    system true
  end

  # If the package includes a systemd init script we don't want it taking precedence over ours
  file "/lib/systemd/system/#{new_resource.log_format}.service" do
    action :delete
  end

  template "init_#{new_resource.log_format}" do
    path template_path(new_resource.log_format)
    source 'varnishlog.erb'
    cookbook 'varnish'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      config: new_resource
    )
    action :create
    notifies :restart, "service[#{new_resource.log_format}]", :delayed
    notifies :run, 'execute[systemctl-daemon-reload]', :immediately
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
  "/etc/systemd/system/#{log_format}.service"
end
