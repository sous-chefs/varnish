class Chef
  class Resource
    # Configure a default Varnish VCL
    class VarnishDefaultVcl < Chef::Resource::LWRPBase
      self.resource_name = :varnish_default_vcl

      actions :configure
      default_action :configure

      attribute :name, kind_of: String, name_attribute: true
      attribute :backend_host, kind_of: String, default: 'localhost'
      attribute :backend_port, kind_of: Fixnum, default: 8080
      attribute :vcl_source, kind_of: String, default: 'lib_default.vcl.erb'
      attribute :vcl_cookbook, kind_of: String, default: 'varnish'
      attribute :vcl_parameters, kind_of: Hash, default: {}
    end
  end

  class Provider
    # Configure a default Varnish VCL
    class VarnishDefaultVcl < Chef::Provider::LWRPBase
      include VarnishCookbook::Helpers
      def whyrun_supported?
        true
      end

      use_inline_resources

      def action_configure
        configure_varnish_vcl
      end

      def configure_varnish_vcl
        template '/etc/varnish/default.vcl' do
          source new_resource.vcl_source
          cookbook new_resource.vcl_cookbook
          owner 'root'
          group 'root'
          mode '0644'
          variables(
            config: new_resource,
            varnish_version: varnish_version,
            parameters: new_resource.vcl_parameters
          )
          action :create
          notifies :reload, 'service[varnish]', :delayed
        end
      end
    end
  end
end
