require_relative "./test_helper.rb"


describe_recipe "varnish::default" do
  include Helpers::VarnishTest
  describe "services" do
    it "starts the varnish service" do
      service("varnish").must_be_running
    end

    it "sets the varnish service to start on boot" do
      service("varnish").must_be_enabled
    end
  end

	it "listens on the desired HTTP Port" do
    begin
      tries ||= 1
      http_port = node['varnish']['listen_port']
      response = Net::HTTP.get_response(node['ipaddress'], "/", http_port)
    rescue
      #We don't care to do much other then let this test fail and others
      Chef::Log.info("Varnish HTTP listner is not available yet")
      sleep(5)
      retry unless (tries -= 1).zero?
    end

    # Out of the box, we are unlikely to have a valid backend.
    # pretty much any http response could be legit, so we just
    # want to make sure we get an actual http response of any kind
    response.must_be_kind_of(Net::HTTPResponse)
	end
end
