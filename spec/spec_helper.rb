# frozen_string_literal: true

require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.formatter = :documentation
  config.color = true
end

def stub_resources(version)
  allow(VarnishCookbook::Helpers).to receive(:installed_major_version).and_return(version)
end

def node_resources(node)
  node.normal['memory']['total'] = '100000Kb'
end
