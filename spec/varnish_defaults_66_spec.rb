require_relative 'spec_helper'

describe 'install_varnish::vendor_install' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: [:varnish_config]) do |node|
      node_resources(node)
      node.override['varnish']['major_version'] = 6.6
    end.converge(described_recipe)
  end

  before do
    stub_resources(6.6)
  end

  it do
    expect(chef_run).to create_template('/etc/varnish/varnish.params')
  end

  it do
    expect(chef_run).to create_template('/etc/systemd/system/varnish.service')
  end
end
