# Cookbook Name:: varnish
# Definition:: vmod
# Author:: Kelley Reynolds <kelley.reynolds@rubyscale.com>
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

# Example:
#
#   git_vmod "Statsd" do
#     source "git://github.com/jib/libvmod-statsd.git"
#   end

define :git_vmod, :source => nil, :packages => [] do

  raise "A git source is required for a vmod" unless params[:source]

  # Ensure all of the requisite packages are installed
  ["libtool", "pkg-config", "libpcre3-dev", "git"].concat(params[:packages]).each do |pkg|
    package pkg
  end

  vmod_name = File.basename(params[:source], '.git')

  bash "install #{params[:name]}" do
    cwd node[:varnish][:vmod_build_dir]
    code <<-EOH
    apt-get source varnish
    export VARNISHDIR=`find . -maxdepth 1 -type d -name 'varnish-*'`
    cd $VARNISHDIR
    ./configure && make
    cd ..
    git clone #{params[:source]}
    cd #{vmod_name}
    ./autogen.sh
    ./configure VARNISHSRC=../$VARNISHDIR VMODDIR=/usr/lib/varnish/vmods
    make
    make install
    echo "Finished installation of #{params[:name]}"
    EOH
    not_if { File.exists?("/usr/lib/varnish/vmods/#{vmod_name.gsub("-", "_")}.so") }
  end
end