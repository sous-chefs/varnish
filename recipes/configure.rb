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
include_recipe 'yum-epel'

varnish_repo 'configure' do
  node['varnish']['configure']['repo'].each do |key, value|
    # Skip nils, use false if you want to disable something.
    send(key, value) unless value.nil?
  end
end

package 'varnish' do
  node['varnish']['configure']['package'].each do |key, value|
    send(key, value) unless value.nil?
  end
end

service 'varnish' do
  node['varnish']['configure']['service'].each do |key, value|
    send(key, value) unless value.nil?
  end
end

varnish_config 'default' do
  node['varnish']['configure']['config'].each do |key, value|
    send(key, value) unless value.nil?
  end
end

vcl_template 'default.vcl' do
  node['varnish']['configure']['vcl_template'].each do |key, value|
    send(key, value) unless value.nil?
  end
end

# varnishlog
varnish_log 'default' do
  node['varnish']['configure']['log'].each do |key, value|
    send(key, value) unless value.nil?
  end
end

# varnishncsa
varnish_log 'default_ncsa' do
  log_format 'varnishncsa'
  node['varnish']['configure']['ncsa'].each do |key, value|
    send(key, value) unless value.nil?
  end
end
