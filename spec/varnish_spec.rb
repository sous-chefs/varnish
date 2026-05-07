# frozen_string_literal: true

require_relative 'spec_helper'

describe 'varnish' do
  step_into :varnish
  platform 'ubuntu', '24.04'

  before do
    stub_resources(6.0)
  end

  context 'with default properties' do
    recipe do
      varnish 'default' do
        ncsa_action :configure
      end
    end

    it { is_expected.to configure_varnish_repo('configure') }
    it { is_expected.to install_package('varnish') }
    it { is_expected.to configure_varnish_config('default') }
    it { is_expected.to configure_vcl_template('default.vcl') }
    it { is_expected.to enable_service('varnish') }
    it { is_expected.to start_service('varnish') }
    it { is_expected.to configure_varnish_log('default') }
    it { is_expected.to configure_varnish_log('default_ncsa') }
  end

  context 'with distro packages' do
    recipe do
      varnish 'default' do
        repo_action :nothing
        ncsa_action :configure
      end
    end

    it { is_expected.to_not configure_varnish_repo('configure') }
    it { is_expected.to install_package('varnish') }
  end

  context 'with remove action' do
    recipe do
      varnish 'default' do
        action :remove
      end
    end

    it { is_expected.to unconfigure_varnish_log('default_ncsa') }
    it { is_expected.to unconfigure_varnish_log('default') }
    it { is_expected.to stop_service('varnish') }
    it { is_expected.to disable_service('varnish') }
    it { is_expected.to unconfigure_vcl_template('default.vcl') }
    it { is_expected.to unconfigure_varnish_config('default') }
    it { is_expected.to remove_package('varnish') }
    it { is_expected.to unconfigure_varnish_repo('configure') }
  end
end
