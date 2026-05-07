# frozen_string_literal: true

require 'mixlib/shellout'

module VarnishCookbook
  # Helper methods used by the varnish cookbook
  module Helpers
    extend Chef::Mixin::ShellOut

    extend self # Stubbing with module_function doesn't seem to work

    def installed_major_version
      cmd_str = 'varnishd -V 2>&1'
      cmd = shell_out!(cmd_str)
      cmd_stdout = cmd.stdout.to_s

      raise "Output of #{cmd_str} was nil; can't determine varnish version" unless cmd_stdout
      Chef::Log.debug "#{cmd_str} ran and detected varnish version: #{cmd_stdout}"

      matches = cmd_stdout.match(/varnish-([0-9]\.[0-9])/)
      version_found = matches && matches.first && matches[1]
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

    def default_reload_cmd(major_version)
      if major_version >= 6.1
        '/usr/sbin/varnishreload'
      elsif major_version < 4
        '/usr/bin/varnish_reload_vcl'
      elsif platform_family?('debian')
        '/usr/share/varnish/reload-vcl'
      elsif platform_family?('rhel') && node['platform_version'].to_i >= 8
        '/usr/sbin/varnishreload'
      else
        '/usr/sbin/varnish_reload_vcl'
      end
    end
  end
end
