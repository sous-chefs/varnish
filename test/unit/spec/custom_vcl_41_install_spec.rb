require_relative 'spec_helper'

describe 'install_varnish::custom_vcl_41_install' do
  before { stub_resources('4.1') }
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: %w(varnish_install
                                           varnish_default_config
                                           varnish_default_vcl
                                           varnish_log)) do |node|
      node_resources(node)
    end.converge(described_recipe)
  end

  it 'creates the varnish default config' do
    expect(chef_run).to create_template('/etc/default/varnish')
  end

  it 'creates the varnish default config with the jail and user settings set' do
    expect(chef_run).to render_file('/etc/default/varnish').with_content(/-j unix,user=varnish/)
  end

  it 'creates the default VCL' do
    expect(chef_run).to create_template('/etc/varnish/default.vcl')
  end

  it 'create the default VCL with custom template and parameter' do
    expect(chef_run).to render_file('/etc/varnish/default.vcl').with_content('probe').with_content('/test_url')
  end
end
