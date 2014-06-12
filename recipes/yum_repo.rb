case node['platform']
when 'amazon'
	version = 6
when 'centos', 'redhat'
	if node['platform_version'].to_f > 5 and node['platform_version'].to_f < 6
		version = 5
	else
		if node['platform_version'].to_f > 6 and node['platform_version'].to_f < 7
			version = 6
		end
	end
end

if version.nil? == false
	tmpvalue = Hash.new
	urlvalue = Hash.new
	tmpvalue[5] = "/tmp/varnish-release-3.0-1.el5.noarch.rpm"
	tmpvalue[6] = "/tmp/varnish-release-3.0-1.el6.noarch.rpm"
	urlvalue[5] = "http://repo.varnish-cache.org/redhat/varnish-3.0/el5/noarch/varnish-release/varnish-release-3.0-1.el5.centos.noarch.rpm"
	urlvalue[6] = "http://repo.varnish-cache.org/redhat/varnish-3.0/el6/noarch/varnish-release/varnish-release-3.0-1.el6.noarch.rpm"

	remote_file tmpvalue[version] do
		source urlvalue[version]
		action :create
	end

	rpm_package "varnish-cache-repo" do 
		options "--nosignature"
		source tmpvalue[version]
		action :install
	end

	file tmpvalue[version] do
		action :delete
	end
end
