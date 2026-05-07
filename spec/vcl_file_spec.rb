# frozen_string_literal: true

require_relative 'spec_helper'

describe 'vcl_file' do
  step_into :vcl_file
  platform 'ubuntu', '24.04'

  context 'configure action' do
    recipe do
      vcl_file 'default.vcl'
    end

    it { is_expected.to create_cookbook_file('/etc/varnish/default.vcl') }
  end

  context 'unconfigure action' do
    recipe do
      vcl_file 'default.vcl' do
        action :unconfigure
      end
    end

    it { is_expected.to delete_file('/etc/varnish/default.vcl') }
  end
end
