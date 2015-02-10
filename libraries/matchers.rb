if defined?(ChefSpec)
  def install_varnish(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:varnish_install, :install, resource_name)
  end

  def configure_varnish_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:varnish_default_config, :configure, resource_name)
  end

  def configure_default_vcl(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:varnish_default_vcl, :configure, resource_name)
  end

  def configure_varnish_log(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:varnish_log, :configure, resource_name)
  end
end
