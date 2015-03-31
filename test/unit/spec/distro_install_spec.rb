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

  it 'Installs the varnish package' do
    expect(chef_run).to install_package('varnish')
  end

  it 'enables the varnish service' do
    resource = chef_run.package('varnish')
    expect(resource).to notify('service[varnish]').to('enable').delayed
    expect(resource).to notify('service[varnish]').to('restart').delayed
  end

  it 'enables the varnishlog service' do
    expect(chef_run).to enable_service('varnishlog')
  end

  it 'installs varnish' do
    expect(chef_run).to install_varnish('default')
  end

  it 'configures varnish service' do
    expect(chef_run).to configure_varnish_service('default')
  end

  it 'configures default VCL' do
    expect(chef_run).to configure_default_vcl('default')
  end

  it 'creates the default varnish config' do
    expect(chef_run).to create_template('/etc/default/varnish')
  end

  it 'creates the default VCL' do
    expect(chef_run).to create_template('/etc/varnish/default.vcl')
  end

  it 'sets up varnishncsa logging' do
    expect(chef_run).to configure_varnish_log('default')
  end

  it 'sets up varnishncsa logging' do
    expect(chef_run).to configure_varnish_log('default_ncsa')
  end

  it 'creates the log template' do
    expect(chef_run).to create_template('/etc/default/varnishlog')
  end

  it 'creates the ncsa template' do
    expect(chef_run).to create_template('/etc/default/varnishncsa')
  end

  it 'enables the varnishlog service' do
    expect(chef_run).to enable_service('varnishlog')
  end

  it 'enables the varnishncsa service' do
    expect(chef_run).to enable_service('varnishncsa')
  end
end
