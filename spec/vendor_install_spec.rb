require 'spec_helper'

describe 'install_varnish::varnishncsa' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: [:varnish_default_config, :varnish_log]) do |node|
      node_resources(node)
    end.converge(described_recipe)
  end

  it 'installs varnish' do
    expect(chef_run).to install_package('varnish')
  end

  it 'enables the varnish service, enables and configures the varnishlog service' do
    expect(chef_run).to enable_service('varnishncsa')
    expect(chef_run).to start_service('varnishncsa')
  end

  it 'creates the default varnish config and VCLs' do
    expect(chef_run).to create_template('/etc/default/varnish')
  end

  it 'sets up varnishncsa logging' do
    expect(chef_run).to configure_varnish_log('default_ncsa')
  end

  it 'creates the log & ncsa template, enables the varnishlog and varnishncsa service' do
    expect(chef_run).to create_template('/etc/default/varnishncsa')
    expect(chef_run).to enable_service('varnishncsa')
  end
end
