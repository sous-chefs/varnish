require_relative 'spec_helper'

describe 'install_varnish::vendor_install' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: [:varnish_config]) do |node|
      node_resources(node)
      node.override['varnish']['major_version'] = 6.0
    end.converge(described_recipe)
  end

  before do
    stub_resources(6.0)
  end

  it 'creates the varnish default config' do
    expect(chef_run).to create_template('/etc/default/varnish')
  end

  it 'creates the varnish default config with the user and group settings set' do
    expect(chef_run).to render_file('/etc/default/varnish').with_content(/-j unix,user=varnish/)
  end
end
