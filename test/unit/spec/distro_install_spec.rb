require_relative 'spec_helper'

describe 'install_varnish::distro_install' do
  before { stub_resources }
  let(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: %w(varnish_install
                                           varnish_default_config
                                           varnish_default_vcl
                                           varnish_log)) do |node|
      node_resources(node)
    end.converge(described_recipe)
  end

  it 'Installs the varnish package and enables the services' do
    expect(chef_run).to install_package('varnish')
    expect(chef_run).to install_varnish('default')
    resource = chef_run.package('varnish')

    expect(resource).to notify('service[varnish]').to('enable').delayed
    expect(resource).to notify('service[varnish]').to('restart').delayed
    expect(chef_run).to configure_varnish_service('default')

    expect(chef_run).to enable_service('varnishlog')
    expect(chef_run).to enable_service('varnishncsa')
  end

  it 'configures default VCL and varnish configs' do
    expect(chef_run).to configure_default_vcl('default')
    expect(chef_run).to create_template('/etc/default/varnish')
    expect(chef_run).to create_template('/etc/varnish/default.vcl')
  end

  it 'configures logging and creates templates' do
    expect(chef_run).to configure_varnish_log('default')
    expect(chef_run).to configure_varnish_log('default_ncsa')
    expect(chef_run).to create_template('/etc/default/varnishlog')
    expect(chef_run).to create_template('/etc/default/varnishncsa')
  end
end
