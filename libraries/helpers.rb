require 'mixlib/shellout'

module VarnishCookbook
  # Helper methods used by the varnish cookbook
  module Helpers
    extend Chef::Mixin::ShellOut

    # rubocop:disable Style/ModuleFunction
    extend self # Stubbing with module_function doesn't seem to work

    def supported_major_versions
      [
        3.0, 4.0, 4.1, 5, 5.0, 5.1, 5.2, 6.0, 6.1, 6.2, 6.3,
        6.4, 6.5, 6.6, 7.0, 7.1, 7.2, 7.3, 7.4, 7.5, 7.6, 7.7
      ]
    end

    def installed_major_version
      cmd_str = 'varnishd -V 2>&1'
      cmd = shell_out!(cmd_str)
      cmd_stdout = cmd.stdout.to_s

      raise "Output of #{cmd_str} was nil; can't determine varnish version" unless cmd_stdout
      Chef::Log.debug "#{cmd_str} ran and detected varnish version: #{cmd_stdout}"

      matches = cmd_stdout.match(/varnish-([0-9]\.[0-9])/)
      version_found = matches && matches[0] && matches[1]
      raise "Cannot parse varnish version from #{cmd_stdout}" unless version_found

      matches[1].to_f
    rescue => ex
      Chef::Log.warn 'Unable to run varnishd to get version.'
      raise ex
    end

    def percent_of_total_mem(total_mem, percent)
      "#{(total_mem[0..-3].to_i * (percent / 100.0)).to_i}K"
    end

    # Varnish expects `hostname` which isn't always the same as node["hostname"]
    def hostname
      shell_out!('hostname').stdout.strip
    end

    def systemd_daemon_reload
      execute 'systemctl-daemon-reload' do
        command '/bin/systemctl --system daemon-reload'
        action :nothing
      end
    end
  end
end
