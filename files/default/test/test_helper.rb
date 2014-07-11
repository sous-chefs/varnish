require 'minitest/spec'
require 'net/http'

module Helpers
  # pull in the needed minitest methods
  module VarnishTest
    include MiniTest::Chef::Assertions
    include MiniTest::Chef::Context
    include MiniTest::Chef::Resources
  end
end
