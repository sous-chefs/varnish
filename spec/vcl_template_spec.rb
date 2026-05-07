# frozen_string_literal: true

require_relative 'spec_helper'

describe 'vcl_template' do
  step_into :vcl_template
  platform 'ubuntu', '24.04'

  before do
    stub_resources(6.0)
  end

  context 'configure action' do
    recipe do
      vcl_template 'default.vcl'
    end

    it { is_expected.to create_template('/etc/varnish/default.vcl') }
  end

  context 'unconfigure action' do
    recipe do
      vcl_template 'default.vcl' do
        action :unconfigure
      end
    end

    it { is_expected.to delete_file('/etc/varnish/default.vcl') }
  end
end
