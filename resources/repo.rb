provides :varnish_repo
property :major_version, Float, default: 6.4
property :fetch_gpg_key, [true, false], default: false

action :configure do
  if platform_family?('debian')
    varnish_repo_debian 'debian' do
      varnish_repo new_resource.varnish_repo
      major_version new_resource.major_version
      fetch_gpg_key new_resource.fetch_gpg_key
    end
  elsif platform_family?('debian')
    varnish_repo_redhat 'redhat' do
      varnish_repo new_resource.varnish_repo
      major_version new_resource.major_version
    end
  else
    log 'Unsupported platform' do
      level :fatal
    end
  end
end
