# frozen_string_literal: true

require_relative 'spec_helper'

describe 'varnish_config' do
  step_into :varnish_config
  platform 'ubuntu', '24.04'

  before do
    stub_resources(6.0)
  end

  context 'configure action' do
    recipe do
      varnish_config 'default' do
        major_version 6.0
      end
    end

    it { is_expected.to create_template('/etc/varnish/varnish.params') }
    it { is_expected.to create_cookbook_file('/usr/share/varnish/reload-vcl') }
    it { is_expected.to create_template('/etc/systemd/system/varnish.service') }
  end

  context 'unconfigure action' do
    recipe do
      varnish_config 'default' do
        major_version 6.0
        action :unconfigure
      end
    end

    it { is_expected.to delete_file('/etc/varnish/varnish.params') }
    it { is_expected.to delete_file('/usr/share/varnish/reload-vcl') }
    it { is_expected.to delete_file('/etc/systemd/system/varnish.service') }
  end
end
