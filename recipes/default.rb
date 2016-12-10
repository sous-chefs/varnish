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

varnish_repo 'install' do
  only_if { node['varnish']['use_default_repo'] }
end

package 'varnish' do
  version node['varnish']['version'] # Default's to nil which would be the latest
end

varnish_default_config 'default' do
  conf_source node['varnish']['conf_source']
  conf_cookbook node['varnish']['conf_cookbook']
end

vcl_template node['varnish']['vcl_conf'] do
  source node['varnish']['vcl_source']
  cookbook node['varnish']['vcl_cookbook']
  varnish_dir node['varnish']['dir']
  only_if { node['varnish']['vcl_generated'] == true }
end

# The reload-vcl script doesn't support the -j option and breaks reload on ubuntu, this is fixed upstream
cookbook_file '/usr/share/varnish/reload-vcl' do
  extend VarnishCookbook::Helpers
  source 'reload-vcl'
  only_if { platform_family?('debian') && node['varnish']['major_version'] >= 4.1 }
end

service 'varnish' do
  supports restart: true, reload: true
  action [:enable, :start]
end

varnish_log 'default'
