# Encoding: utf-8

require_relative 'spec_helper'

%w(varnish varnishlog varnishncsa).each do |varnish_service|
  describe service(varnish_service) do
    it 'enabled' do
      expect(subject).to be_enabled
    end
    it 'running' do
      expect(subject).to be_running
    end
  end
end

def curl_localhost
  'curl localhost:6081'
end

describe command(curl_localhost) do
  it 'exits zero' do
    expect(subject.exit_status).to eq 0
  end
end

['6081', '6082'].each do |port|
  describe port(port) do
    it 'listens on the correct port' do
      expect(subject).to be_listening
    end
  end
end

def varnish_version
  'varnishd -V 2>&1'
end

describe command(varnish_version) do
  it 'exits zero' do
    expect(subject.exit_status).to eq 0
  end
  it 'returns \'500\' as the content' do
    expect(subject.stdout).to match(/varnish-4/)
  end
end

describe file('/etc/varnish/default.vcl') do
  it 'file content' do
    expect(subject.content).to match(/vcl 4.0/)
  end
end

describe file('/etc/logrotate.d/varnishlog') do
  it 'varnishlog exists' do
    expect(subject).not_to be_file
  end
end
describe file('/etc/logrotate.d/varnishncsa') do
  it 'varnishnsca is not a file' do
    expect(subject).to be_file
  end
end

def thread_pool_max
  'varnishadm -S /etc/varnish/secret -T localhost:6082 param.show thread_pool_max |grep Value'
end

describe command(thread_pool_max) do
  it 'exits zero' do
    expect(subject.exit_status).to eq 0
  end
  it 'returns \'500\' as the content' do
    expect(subject.stdout).to match(/ 500 /)
  end
end
