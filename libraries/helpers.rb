module VarnishCookbook
  # Helper methods to be used in multiple Varnish cookbook libraries.
  module Helpers
    def varnish_version
      cmd = 'varnishd -V 2>&1'
      cmd = Mixlib::ShellOut.new(cmd)
      cmd.environment['HOME'] = ENV.fetch('HOME', '/root')

      begin
        cmd.run_command
        Chef::Log.debug "#{cmd} ran and detected varnish version: #{cmd.stdout}"
        return cmd.stdout.match(/varnish-([0-9])\./).captures[0]
      rescue => ex
        Chef::Log.warn "Unable to run varnishd to get version.\nMessage: #{ex.message}"
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
  end
end
