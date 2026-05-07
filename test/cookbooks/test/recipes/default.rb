# frozen_string_literal: true

varnish 'default' do
  major_version 6.0
  repo_action :nothing
  ncsa_action :configure
  action :install
end
