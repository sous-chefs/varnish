class Chef
  class Resource
    # Install Varnish
    class VarnishInstall < Chef::Resource::LWRPBase
      self.resource_name = :varnish_install
      actions :install
      default_action :install

      attribute :name, kind_of: String, name_attribute: true
      attribute :package_name, kind_of: String, default: 'varnish'
      attribute :vendor_repo, kind_of: [TrueClass, FalseClass], default: false
      attribute :vendor_version, kind_of: String, default: '4.0'
    end
  end

  class Provider
    # Install Varnish
    class VarnishInstall < Chef::Provider::LWRPBase
      use_inline_resources

      def whyrun_supported?
        true
      end

      def action_install
        if new_resource.vendor_repo
          add_vendor_repo
        end

        install_varnish
      end

      def add_vendor_repo
        case node['platform_family']
        when 'debian'
          apt_repository 'varnish-cache' do
            uri "http://repo.varnish-cache.org/#{node['platform']}"
            distribution node['lsb']['codename']
            components ["varnish-#{new_resource.vendor_version}"]
            key "http://repo.varnish-cache.org/#{node['platform']}/GPG-key.txt"
            deb_src true
          end
        when 'rhel', 'fedora'
          yum_repository 'varnish' do
            description "Varnish #{new_resource.vendor_version} repo (#{node['platform_version']} - $basearch)"
            url "http://repo.varnish-cache.org/redhat/varnish-#{new_resource.vendor_version}/el#{node['platform_version'].to_i}/"
            gpgcheck false
            gpgkey 'http://repo.varnish-cache.org/debian/GPG-key.txt'
            action 'create'
          end
        end
      end

      def install_varnish
        package new_resource.package_name do
          action 'install'
          notifies 'enable', "service[#{new_resource.package_name}]", 'delayed'
          notifies 'restart', "service[#{new_resource.package_name}]", 'delayed'
        end

        service 'varnish' do
          supports restart: true, reload: true
          action 'nothing'
        end
      end
    end
  end
end
