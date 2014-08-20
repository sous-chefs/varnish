# Encoding: utf-8

require_relative 'spec_helper'

describe service('varnish') do
  it { should be_enabled }
  it { should be_running }
end
describe port(6081) do
  it { should be_listening }
end
