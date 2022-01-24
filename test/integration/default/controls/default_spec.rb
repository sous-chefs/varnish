control 'hello-world' do
  impact 1
  desc 'Varnish Service should be running'

  describe service('varnish') do
    it { should be_installed }
    it { should be_running }
  end
end
