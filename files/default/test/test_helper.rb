require 'minitest/spec'
require "net/http"

module Helpers
	module VarnishTest
		include MiniTest::Chef::Assertions
		include MiniTest::Chef::Context
		include MiniTest::Chef::Resources
	end
end
