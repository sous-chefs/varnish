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

describe 'Storage bin file exists' do
  it 'Should find the storage file' do
    binfile = Dir.glob('/var/lib/varnish/**/*').find { |e| /varnish_storage.bin/ =~ e }
    binfile.should be_truthy
  end
end

def thread_pool_max
  'varnishadm -S /etc/varnish/secret -T localhost:6082 param.show thread_pool_max'
end

describe command(thread_pool_max) do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/ 500 /) }
end
