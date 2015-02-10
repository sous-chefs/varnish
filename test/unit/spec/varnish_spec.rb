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

  it 'Install the varnish-cache repository' do
    expect(chef_run).to add_apt_repository('varnish-cache')
  end

  it 'Installs Varnish package' do
    expect(chef_run).to install_package('varnish')
  end

  it 'Configure varnish' do
    expect(chef_run).to create_template('/etc/varnish/default.vcl')
    expect(chef_run).to create_template('/etc/default/varnish')
  end

  it 'Enable and start varnish service' do
    expect(chef_run).to enable_service('varnish')
  end

  it 'Start Varnishlog service' do
    expect(chef_run).to start_service('varnishlog')
  end

  context 'Without repo installation && without log_deamon' do
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

    it 'Does not install the varnish repository' do
      expect(chef_run).to_not add_apt_repository('varnish-cache')
    end

    it 'Does not start Varnishlog service' do
      expect(chef_run).to stop_service('varnishlog')
    end
  end
end
