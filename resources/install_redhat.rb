# frozen_string_literal: true

property :version, Float, default: 6.4

action :configure do
  include_recipe 'yum-epel'

  package %w(yum-utils)

  # packagecloud repos omit dot from major version
  version_no_dot = new_resource.version.to_s.tr('.', '')

  yum_repository "varnish-cache_varnish#{version_no_dot}" do
    description "Varnish #{new_resource.version} repo (#{node['platform_version']} - $basearch)"
    baseurl "https://packagecloud.io/varnishcache/varnish#{version_no_dot}/el/#{node['platform_version'].to_i}/$basearch"
    gpgcheck false
    repo_gpgcheck true
    gpgkey "https://packagecloud.io/varnishcache/varnish#{version_no_dot}/gpgkey"
    action :create
  end

  package 'varnish'
end
