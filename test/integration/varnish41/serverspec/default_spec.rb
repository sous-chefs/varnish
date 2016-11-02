# Encoding: utf-8

require_relative 'spec_helper'

describe service('varnish') do
  it 'enabled' do
    expect(subject).to be_enabled
  end
  it 'running' do
    expect(subject).to be_running
  end
end
describe port(6081) do
  it 'listens on the correct port' do
    expect(subject).to be_listening
  end
end
