require_relative 'spec_helper'

describe 'install_varnish::vendor_install' do
  before { stub_resources }
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: %w(varnish_install
                                           varnish_default_config
                                           varnish_default_vcl
                                           varnish_log)) do |node|
      node_resources(node)
    end.converge(described_recipe)
  end

  it 'installs varnish' do
    expect(chef_run).to install_varnish('default')
    expect(chef_run).to install_package('varnish')
  end

  it 'enables the varnish service, enables and configures the varnishlog service' do
    resource = chef_run.package('varnish')
    expect(resource).to notify('service[varnish]').to('enable').delayed
    expect(resource).to notify('service[varnish]').to('restart').delayed

    expect(chef_run).to enable_service('varnishlog')
    expect(chef_run).to configure_varnish_service('default')
  end

  it 'creates the default varnish config and VCLs' do
    expect(chef_run).to create_template('/etc/default/varnish')
    expect(chef_run).to configure_default_vcl('default')
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
