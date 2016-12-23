require 'chefspec'
require 'chefspec/berkshelf'
require_relative '../../../libraries/helpers'

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '14.04'
end

def stub_resources
  allow(VarnishCookbook::Helpers).to receive(:installed_major_version).and_return(4.0)
end

def node_resources(node)
  node.set['memory']['total'] = '100000Kb'
end
