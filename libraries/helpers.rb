module VarnishCookbook
  # Helper methods to be used in multiple Varnish cookbook libraries.
  module Helpers

    def percent_of_total_mem(percent)
      "#{(node['memory']['total'][0..-3].to_i * (percent / 100)).to_i}K"
    end

    #def systemd_daemon_reload
    #  execute 'systemctl-daemon-reload' do
    #    command '/bin/systemctl --system daemon-reload'
    #    action :nothing
    #  end
    #end
  end
end
