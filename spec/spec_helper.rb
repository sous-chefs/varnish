# frozen_string_literal: true

require 'chefspec'
require 'chefspec/policyfile'
require_relative '../libraries/helpers'

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '24.04'
  config.log_level = :error
end

def stub_resources(version)
  allow(VarnishCookbook::Helpers).to receive(:installed_major_version).and_return(version)
end

def node_resources(node)
  node.normal['memory']['total'] = '100000Kb'
end
