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
  end
end
