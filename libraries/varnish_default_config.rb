class Chef
  class Resource
    # Configure the Varnish service.
    class VarnishDefaultConfig < Chef::Resource::LWRPBase
      self.resource_name = :varnish_default_config

      actions :configure
      default_action :configure

      attribute :name, kind_of: String, name_attribute: true

      # Service config options
      attribute :start_on_boot, kind_of: [TrueClass, FalseClass],
                                default: true
      attribute :max_open_files, kind_of: Fixnum, default: 131_072
      attribute :max_locked_memory, kind_of: Fixnum, default: 82_000
      attribute :instance_name, kind_of: String, default: nil

      # Daemon options
      attribute :listen_address, kind_of: String, default: nil
      attribute :listen_port, kind_of: Fixnum, default: 6081
      attribute :path_to_vcl, kind_of: String, default: '/etc/varnish/default.vcl'
      attribute :admin_listen_address, kind_of: String, default: '127.0.0.1'
      attribute :admin_listen_port, kind_of: Fixnum, default: 6082
      attribute :user, kind_of: String, default: 'varnish'
      attribute :group, kind_of: String, default: 'varnish'
      attribute :ttl, kind_of: Fixnum, default: 120
      attribute :storage, kind_of: String, default: 'file',
                          equal_to: ['file', 'malloc']
      attribute :file_storage_path, kind_of: String,
                                    default: '/var/lib/varnish/%s_storage.bin'
      attribute :file_storage_size, kind_of: String, default: '1G'
      attribute :malloc_size, kind_of: String, default: nil
      attribute :parameters, kind_of: Hash,
                             default: { 'thread_pools' => '4',
                                        'thread_pool_min' => '5',
                                        'thread_pool_max' => '500',
                                        'thread_pool_timeout' => '300' }
      attribute :path_to_secret, kind_of: String, default: '/etc/varnish/secret'
    end
  end

  class Provider
    # Configure the Varnish service.
    class VarnishDefaultConfig < Chef::Provider::LWRPBase
      include VarnishCookbook::Helpers

      def whyrun_supported?
        true
      end

      use_inline_resources

      def action_configure
        define_systemd_daemon_reload if node['init_package'] == 'systemd'
        configure_varnish_service
      end

      def configure_varnish_service
        svc = service 'varnish' do
          supports restart: true, reload: true
          action :nothing
        end

        tmp = template '/etc/default/varnish' do
          path varnish_platform_defaults[:path]
          source varnish_platform_defaults[:source]
          cookbook 'varnish'
          owner 'root'
          group 'root'
          mode '0644'
          variables(
            config: new_resource,
            exec_reload_command: varnish_exec_reload_command
          )
          action :nothing
          notifies :restart, 'service[varnish]', :delayed
          notifies :run, 'execute[systemctl-daemon-reload]', :immediately if node['init_package'] == 'systemd'
        end
        tmp.run_action(:create)

        if tmp.updated_by_last_action?
          svc.run_action(:restart)
        end

        new_resource.updated_by_last_action(true) if tmp.updated_by_last_action?
      end
    end
  end
end
