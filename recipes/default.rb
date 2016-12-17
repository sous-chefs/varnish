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

# The reload-vcl script doesn't support the -j option in 4.1 and breaks reload on ubuntu.
# This is fixed upstream but could cause issues if you are using the distro package.

directory '/usr/share/varnish' do
  recursive true
end
cookbook_file '/usr/share/varnish/reload-vcl' do
  extend VarnishCookbook::Helpers
  source 'reload-vcl'
  only_if { platform_family?('debian') }
end

# The varnishlog group was removed from some of the more recent varnish packages.
group 'varnishlog' do
  system true
end

