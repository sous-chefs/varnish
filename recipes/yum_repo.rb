# Cookbook Name:: varnish
# Recipe:: yum_repo
# Author:: Mike Mallett <mike.mallett@openconcept.ca>
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

yum_repository "varnish" do
  name "varnish"
  description "Varnish repository for RHEL-type systems"
  url "http://repo.varnish-cache.org/redhat/varnish-3.0/el5"
#  key "RPM-GPG-KEY-VARNISH"
  action :add
end
