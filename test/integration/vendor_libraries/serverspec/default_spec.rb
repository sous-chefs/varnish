# Encoding: utf-8

require_relative 'spec_helper'

%w(varnish varnishlog varnishncsa).each do |varnish_service|
  describe service(varnish_service) do
    it { should be_enabled }
    it { should be_running }
  end
end

def curl_localhost
  'curl localhost:6081'
end

describe command(curl_localhost) do
  its(:exit_status) { should eq 0 }
end

['6081', '6082'].each do |port|
  describe port(port) do
    it { should be_listening }
  end
end

def varnish_version
  'varnishd -V 2>&1'
end

describe command(varnish_version) do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/varnish-4/) }
end

describe file('/etc/varnish/default.vcl') do
  its(:content) { should match(/vcl 4.0/) }
end

describe file('/etc/logrotate.d/varnishlog') do
  it { should_not be_file }
end
describe file('/etc/logrotate.d/varnishncsa') do
  it { should be_file }
end

def thread_pool_max
  'varnishadm -S /etc/varnish/secret -T localhost:6082 param.show thread_pool_max |grep Value'
end

describe command(thread_pool_max) do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/500/) }
end
