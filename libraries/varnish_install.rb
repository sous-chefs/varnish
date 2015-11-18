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
          repo = apt_repository 'varnish-cache' do
            uri "http://repo.varnish-cache.org/#{node['platform']}"
            distribution node['lsb']['codename']
            components ["varnish-#{new_resource.vendor_version}"]
            key "http://repo.varnish-cache.org/#{node['platform']}/GPG-key.txt"
            deb_src true
          end
          repo.run_action(:add)
          new_resource.updated_by_last_action(true) if repo.updated_by_last_action?
        when 'rhel', 'fedora'
          repo = yum_repository 'varnish' do
            description "Varnish #{new_resource.vendor_version} repo (#{node['platform_version']} - $basearch)"
            url "http://repo.varnish-cache.org/redhat/varnish-#{new_resource.vendor_version}/el#{node['platform_version'].to_i}/"
            gpgcheck false
            gpgkey 'http://repo.varnish-cache.org/debian/GPG-key.txt'
          end
          repo.run_action(:create)
          new_resource.updated_by_last_action(true) if repo.updated_by_last_action?
        end
      end

      def install_varnish
        svc = service 'varnish' do
          supports restart: true, reload: true
          action :nothing
        end

        pack = package new_resource.package_name do
          action :nothing
          notifies 'enable', "service[#{new_resource.package_name}]", 'delayed'
          notifies 'restart', "service[#{new_resource.package_name}]", 'delayed'
        end

        pack.run_action(:install)
        if pack.updated_by_last_action?
          svc.run_action(:enable)
          svc.run_action(:restart)
        end

        new_resource.updated_by_last_action(true) if svc.updated_by_last_action? || pack.updated_by_last_action?
      end
    end
  end
end
