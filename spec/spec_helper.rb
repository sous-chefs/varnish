require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '14.04'
end

def node_resources(node)
  node.set['memory']['total'] = '100000Kb'
end
