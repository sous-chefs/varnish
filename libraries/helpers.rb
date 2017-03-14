require 'mixlib/shellout'

module VarnishCookbook
  # Helper methods used by the varnish cookbook
  module Helpers
    extend Chef::Mixin::ShellOut

    # rubocop:disable ModuleFunction
    extend self # Stubbing with module_function doesn't seem to work

    def installed_major_version
      cmd_str = 'varnishd -V 2>&1'
      cmd = shell_out!(cmd_str)
      cmd_stdout = cmd.stdout.to_s

      raise "Output of #{cmd_str} was nil; can't determine varnish version" unless cmd_stdout
      Chef::Log.debug "#{cmd_str} ran and detected varnish version: #{cmd_stdout}"

      matches = cmd_stdout.match(/varnish-([0-9]\.[0-9])/)
      version_found = matches && matches[0] && matches[1]
      raise "Cannot parse varnish version from #{cmd_stdout}" unless version_found

      return matches[1].to_f
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
