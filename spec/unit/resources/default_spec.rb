# frozen_string_literal: true

require 'spec_helper'

describe 'apache2_install' do
  step_into :varnish_install, :varnish_config
  platform 'ubuntu'

  context 'install an varnish with default properties' do
    recipe do
      varnish_install 'default'
      varnish_config ''
    end

    it 'should create the params template' do
      is_expected.to create_template('/etc/varnish/varnish.params')
    end

    it 'should create the varnish service resource' do
      is_expected.to nothing_service('varnish')
    end

    it 'should create the reload vcl file' do
      is_expected.to create_cookbook_file '/usr/share/varnish/reload-vcl'
    end

    it 'should create the service configuration template' do
      is_expected.to create_template('/etc/default/varnish')
      is_expected.to render_file('/etc/default/varnish')
        .with_content(/network.target/)
        .with_content(/82000/)
        .with_content(/131072/)
    end
  end
end
