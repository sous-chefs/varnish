# Cookbook Name:: varnish
# Recipe:: default
#
# Copyright 2008-2009, Joe Williams <joe@joetify.com>
# Copyright 2014. Patrick Connolly <patrick@myplanetdigital.com>
# Copyright 2015. Rackspace, US Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'apt'
include_recipe 'varnish::default'

varnish_repo 'configure' do
  major_version node['varnish']['major_version']
end

package 'varnish'

service 'varnish' do
  action [:enable, :start]
end

# needed for tests because this directory is not always on created instances
directory 'logrotate' do
  path '/etc/logrotate.d'
  user 'root'
  group 'root'
  mode '0755'
  action :create
end

varnish_default_config 'default'

vcl_template 'default' do
  source 'default.vcl.erb'
  variables(
    config: {
      major_version: node['varnish']['major_version'],
      backend_host: '127.0.0.10',
      backend_port: '8080'
    }
  )
end

# varnishlog
varnish_log 'default'

# varnishncsa
varnish_log 'default_ncsa' do
  file_name '/var/log/varnish/varnishncsa.log'
  pid '/var/run/varnishncsa.pid'
  log_format 'varnishncsa'
  ncsa_format_string '%h|%l|%u|%t|\"%r\"|%s|%b|\"%{Referer}i\"|\"%{User-agent}i\"'
  logrotate false
end
