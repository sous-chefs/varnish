if defined?(ChefSpec)
  def configure_varnish_repo(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:varnish_repo, :configure, resource_name)
  end

  def configure_vcl_file(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:vcl_file, :configure, resource_name)
  end

  def configure_vcl_template(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:vcl_template, :configure, resource_name)
  end

  def configure_varnish_log(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:varnish_log, :configure, resource_name)
  end
end
