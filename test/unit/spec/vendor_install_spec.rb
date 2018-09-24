require_relative 'spec_helper'

describe 'install_varnish::vendor_install' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: %w(varnish_repo varnish_config vcl_template vcl_file varnish_log)) do |node|
      node_resources(node)
    end.converge(described_recipe)
  end

  before do
    stub_resources(4.0)
  end

  it 'does not configure the varnish vendor repo' do
    expect(chef_run).to configure_varnish_repo('configure')
  end

  it 'installs varnish' do
    expect(chef_run).to install_package('varnish')
  end

  it 'enables the varnish service, enables and configures the varnishlog service' do
    expect(chef_run).to enable_service('varnish')
    expect(chef_run).to start_service('varnish')
    expect(chef_run).to enable_service('varnishlog')
    expect(chef_run).to start_service('varnishlog')
  end

  it 'creates the default varnish config and VCLs' do
    expect(chef_run).to configure_vcl_template('default.vcl')
    expect(chef_run).to create_template('/etc/default/varnish')
    expect(chef_run).to create_template('/etc/varnish/default.vcl')
  end

  it 'sets up varnishncsa logging' do
    expect(chef_run).to configure_varnish_log('default')
    expect(chef_run).to configure_varnish_log('default_ncsa')
  end

  it 'creates the log & ncsa template, enables the varnishlog and varnishncsa service' do
    expect(chef_run).to create_template('/etc/default/varnishlog')
    expect(chef_run).to create_template('/etc/default/varnishncsa')
    expect(chef_run).to enable_service('varnishlog')
    expect(chef_run).to enable_service('varnishncsa')
  end
end
