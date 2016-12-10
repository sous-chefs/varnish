require_relative 'spec_helper'

describe 'varnish::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node_resources(node)
    end.converge(described_recipe)
  end

  it 'configures the varnish vendor repo' do
    expect(chef_run).to_not configure_varnish_repo('vendor')
  end

  it 'installs varnish' do
    expect(chef_run).to install_package('varnish')
  end

  it 'enables the varnish service, enables and configures the varnishlog service' do
    expect(chef_run).to enable_service('varnish')
    expect(chef_run).to start_service('varnish')
  end

  it 'creates the default varnish config and VCLs' do
    expect(chef_run).to configure_vcl_template('default')
  end

  it 'sets up varnishncsa logging' do
    expect(chef_run).to configure_varnish_log('default')
  end
end
