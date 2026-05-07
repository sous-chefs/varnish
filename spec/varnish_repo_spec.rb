# frozen_string_literal: true

require_relative 'spec_helper'

describe 'varnish_repo' do
  context 'on ubuntu' do
    step_into :varnish_repo
    platform 'ubuntu', '24.04'

    recipe do
      varnish_repo 'configure' do
        major_version 6.0
      end
    end

    it { is_expected.to add_apt_repository('varnish-cache_6.0') }
    it { is_expected.to add_apt_preference('varnish') }
  end

  context 'on almalinux' do
    step_into :varnish_repo
    platform 'almalinux', '8'

    recipe do
      varnish_repo 'configure' do
        major_version 6.0
      end
    end

    it { is_expected.to disable_dnf_module('varnish') }
    it { is_expected.to create_yum_repository('varnish-cache_6.0') }
  end
end
