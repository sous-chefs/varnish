# frozen_string_literal: true

property :version, Float, default: 6.4
property :fetch_gpg_key, [true, false], default: false

action :configure do
  if platform_family?('debian')
    varnish_install_debian 'debian' do
      version new_resource.version
      fetch_gpg_key new_resource.fetch_gpg_key
    end
  elsif platform_family?('debian')
    varnish_install_redhat 'redhat' do
      version new_resource.version
    end
  else
    log 'Unsupported platform' do
      level :fatal
    end
  end
end
