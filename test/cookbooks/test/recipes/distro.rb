# frozen_string_literal: true

varnish 'default' do
  repo_action :nothing
  ncsa_action :configure
  ncsa_format_string 'ncsa_format_string_test|%h|%l|%u|%t|\"%r\"|%s|%b|\"%{Referer}i\"|\"%{Varnish:hitmiss}x\"|\"%{User-agent}i\"'
  action :install
end
