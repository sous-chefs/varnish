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
      attribute :listen_address, kind_of: Fixnum, default: nil
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
      def whyrun_supported?
        true
      end

      use_inline_resources

      def action_configure
        configure_varnish_service
      end

      def configure_varnish_service
        template '/etc/default/varnish' do
          if node['platform_family'] == 'debian'
            path '/etc/default/varnish'
            source 'lib_default.erb'
          elsif node['init_package'] == 'systemd'
            path '/etc/varnish/varnish.params'
            source 'lib_default_systemd.erb'
          else
            path '/etc/sysconfig/varnish'
            source 'lib_default.erb'
          end
          cookbook 'varnish'
          owner 'root'
          group 'root'
          mode '0644'
          variables(
            config: new_resource
          )
          action :create
          notifies :restart, 'service[varnish]', :delayed
        end
      end
    end
  end
end
