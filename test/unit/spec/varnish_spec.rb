require_relative 'spec_helper'

describe 'debian::varnish::default' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(
      platform: 'debian', version: '7.4'
    ) do |node|
      node.automatic['memory']['total'] = '2048kB'
      node.automatic['ipaddress'] = '1.1.1.1'
    end
    runner.converge('varnish::default')
  end

  it 'Install the varnish-cache repository and install the package' do
    expect(chef_run).to add_apt_repository('varnish-cache')
    expect(chef_run).to install_package('varnish')
  end

  it 'Configure varnish, enable and start services' do
    expect(chef_run).to create_template('/etc/varnish/default.vcl')
    expect(chef_run).to create_template('/etc/default/varnish')
    expect(chef_run).to enable_service('varnish')
    expect(chef_run).to start_service('varnishlog')
  end
end

describe 'varnish without repo installation && without log_deamon' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(
      platform: 'debian', version: '7.4'
    ) do |node|
      node.automatic['memory']['total'] = '2048kB'
      node.automatic['ipaddress'] = '1.1.1.1'
      node.set['varnish']['use_default_repo'] = false
      node.set['varnish']['log_daemon'] = false
    end
    runner.converge('varnish::default')
  end

  it 'Does not install the varnish repository or start service' do
    expect(chef_run).to_not add_apt_repository('varnish-cache')
    expect(chef_run).to stop_service('varnishlog')
  end
end
