module VarnishCookbook
  # Helper methods to be used in multiple Varnish cookbook libraries.
  module Helpers
    def varnish_version
      cmd_str = 'varnishd -V 2>&1'
      cmd = Mixlib::ShellOut.new(cmd_str)
      cmd.environment['HOME'] = ENV.fetch('HOME', '/root')

      begin
        cmd.run_command
        cmd_stdout = cmd.stdout.to_s

        fail "Output of #{cmd_str} was nil; can't determine varnish version" unless cmd_stdout
        Chef::Log.debug "#{cmd_str} ran and detected varnish version: #{cmd_stdout}"

        matches = cmd_stdout.match(/varnish-([0-9])\./)
        version_found = matches && matches.captures && matches.captures[0]
        fail "Cannot parse varnish version from #{cmd_stdout}" unless version_found

        return version_found
      rescue => ex
        Chef::Log.warn 'Unable to run varnishd to get version.'
        raise ex
      end
    end

    def varnish_exec_reload_command
      if platform_family?('debian')
        return '/usr/share/varnish/reload-vcl'
      else
        return '/usr/sbin/varnish_reload_vcl'
      end
    end

    def varnish_platform_defaults
      if node['init_package'] == 'init' && platform_family?('debian')
        # Ubuntu < 15.04, Debian < 8
        return { path: '/etc/default/varnish', source: 'lib_default.erb' }
      elsif node['init_package'] == 'systemd'
        # Ubuntu >= 15.04, Debian >= 8, CentOS >= 7
        return { path: '/etc/systemd/system/varnish.service', source: 'lib_default_systemd.erb' }
      else
        # CentOS < 7
        return { path: '/etc/sysconfig/varnish', source: 'lib_default.erb' }
      end
    end

    def define_systemd_daemon_reload
      execute 'systemctl-daemon-reload' do
        command '/bin/systemctl --system daemon-reload'
        action :nothing
      end
    end
  end
end
