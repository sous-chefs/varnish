#
# Cookbook:: filesystem
# Spec:: default
#
# Copyright:: 2017, Sous Chefs, All Rights Reserved.

require 'spec_helper'

describe 'varnish::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
