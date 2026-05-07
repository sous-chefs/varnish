# frozen_string_literal: true

require_relative 'spec_helper'

describe 'varnish_log' do
  step_into :varnish_log
  platform 'ubuntu', '24.04'

  before do
    stub_resources(6.0)
    allow(::File).to receive(:exist?).and_call_original
    allow(::File).to receive(:exist?).with('/etc/logrotate.d').and_return(true)
  end

  context 'configure varnishlog' do
    recipe do
      varnish_log 'default'
    end

    it { is_expected.to create_group('varnishlog') }
    it { is_expected.to delete_file('/lib/systemd/system/varnishlog.service') }
    it { is_expected.to create_template('init_varnishlog') }
    it { is_expected.to create_template('/etc/logrotate.d/varnishlog') }
    it { is_expected.to enable_service('varnishlog') }
    it { is_expected.to start_service('varnishlog') }
  end

  context 'configure varnishncsa' do
    recipe do
      varnish_log 'default_ncsa' do
        log_format 'varnishncsa'
      end
    end

    it { is_expected.to create_template('init_varnishncsa') }
    it { is_expected.to enable_service('varnishncsa') }
    it { is_expected.to start_service('varnishncsa') }
  end

  context 'unconfigure action' do
    recipe do
      varnish_log 'default' do
        action :unconfigure
      end
    end

    it { is_expected.to stop_service('varnishlog') }
    it { is_expected.to disable_service('varnishlog') }
    it { is_expected.to delete_file('/etc/systemd/system/varnishlog.service') }
    it { is_expected.to delete_file('/etc/logrotate.d/varnishlog') }
  end
end
