# frozen_string_literal: true

provides :varnish
unified_mode true

property :major_version, Float, default: 6.0
property :repo_action, [Symbol, Array], default: :configure
property :package_action, [Symbol, Array], default: :install
property :package_name, String, default: 'varnish'
property :package_version, [String, nil]
property :service_action, [Symbol, Array], default: [:enable, :start]
property :service_name, String, default: 'varnish'
property :config_action, [Symbol, Array], default: :configure
property :vcl_action, [Symbol, Array], default: :configure
property :log_action, [Symbol, Array], default: :configure
property :ncsa_action, [Symbol, Array], default: :nothing
property :ncsa_format_string, [String, nil]
property :vcl_source, String, default: 'default.vcl.erb'
property :vcl_cookbook, [String, nil], default: 'varnish'
property :backend_host, String, default: '127.0.0.1'
property :backend_port, String, default: '8080'
property :vcl_variables, Hash, default: lazy {
  {
    config: {
      backend_host: backend_host,
      backend_port: backend_port,
    },
  }
}
property :listen_address, String, default: '0.0.0.0'
property :listen_port, Integer, default: 6081
property :storage, String, default: 'file', equal_to: %w(file malloc)
property :malloc_percent, [Integer, nil], default: 33
property :malloc_size, [String, nil]
property :parameters, Hash, default: {
  'thread_pools' => '4',
  'thread_pool_min' => '5',
  'thread_pool_max' => '500',
  'thread_pool_timeout' => '300',
}

default_action :install

action :install do
  include_recipe 'yum-epel' if platform_family?('rhel', 'fedora')

  unless Array(new_resource.repo_action).all? { |action| action == :nothing }
    varnish_repo 'configure' do
      major_version new_resource.major_version
      action new_resource.repo_action
    end
  end

  package new_resource.package_name do
    version new_resource.package_version if new_resource.package_version
    action new_resource.package_action
  end

  varnish_config 'default' do
    major_version new_resource.major_version
    listen_address new_resource.listen_address
    listen_port new_resource.listen_port
    storage new_resource.storage
    malloc_percent new_resource.malloc_percent
    malloc_size new_resource.malloc_size
    parameters new_resource.parameters
    action new_resource.config_action
  end

  vcl_template 'default.vcl' do
    source new_resource.vcl_source
    cookbook new_resource.vcl_cookbook if new_resource.vcl_cookbook
    variables Chef::Mixin::DeepMerge.deep_merge(
      {
        config: {
          major_version: new_resource.major_version,
        },
      },
      new_resource.vcl_variables
    )
    action new_resource.vcl_action
  end

  service new_resource.service_name do
    action new_resource.service_action
  end

  varnish_log 'default' do
    major_version new_resource.major_version
    action new_resource.log_action
  end

  varnish_log 'default_ncsa' do
    log_format 'varnishncsa'
    major_version new_resource.major_version
    ncsa_format_string new_resource.ncsa_format_string if new_resource.ncsa_format_string
    action new_resource.ncsa_action
  end
end

action :remove do
  varnish_log 'default_ncsa' do
    log_format 'varnishncsa'
    action :unconfigure
  end

  varnish_log 'default' do
    action :unconfigure
  end

  service new_resource.service_name do
    action [:stop, :disable]
  end

  vcl_template 'default.vcl' do
    action :unconfigure
  end

  varnish_config 'default' do
    major_version new_resource.major_version
    action :unconfigure
  end

  package new_resource.package_name do
    action :remove
  end

  varnish_repo 'configure' do
    major_version new_resource.major_version
    action :unconfigure
  end
end
