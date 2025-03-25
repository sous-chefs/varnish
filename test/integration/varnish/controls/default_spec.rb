version = input('version', value: 0)
ncsa_format_string = input('ncsa_format_string')
full_stack = input('full_stack')
os_family = os.family
os_release = os.release

control 'default' do
  describe command 'varnishd -V' do
    its('exit_status') { should eq 0 }
    its('stderr') { should match(/varnish-#{version}/) } unless version == 0
  end

  describe service 'varnish' do
    it { should be_enabled }
    it { should be_running }
  end

  if full_stack
    describe port 80 do
      it { should be_listening }
      its('protocols') { should include 'tcp' }
      its('addresses') { should include '0.0.0.0' }
    end

    describe port 8080 do
      it { should be_listening }
      its('protocols') { should include 'tcp' }
      its('addresses') { should include '0.0.0.0' }
    end

    describe http 'localhost' do
      its('status') { should cmp 200 }
      its('body') { should match /Hello World!/ }
    end

    # This needs to run as a command so that varnish can cache
    describe command('sleep 2; curl -v localhost') do
      it 'exits zero' do
        expect(subject.exit_status).to eq 0
      end
      it 'returns the correct file' do
        expect(subject.stdout).to match(/Hello World!/)
      end
      it 'the file is cached in varnish' do
        expect(subject.stderr).to_not match(/Age: 0\s*/)
        expect(subject.stderr).to match(/Age: [0-9]+/)
      end
    end

    describe http 'localhost:80' do
      its('status') { should cmp 200 }
      its('headers.Server') { should match 'nginx' }
      its('headers.X-Varnish') { should match /[0-9]+/ }
      its('headers.Via') { should match 'varnish' }
    end
  else
    %w(varnishlog varnishncsa).each do |varnish_service|
      describe service varnish_service do
        it { should be_enabled }
        it { should be_running }
      end
    end

    describe port 6081 do
      it { should be_listening }
      its('protocols') { should include 'tcp' }
      its('addresses') { should include '0.0.0.0' }
    end

    describe http 'localhost:6081' do
      its('status') { should cmp 503 }
      its('headers.Server') { should cmp 'Varnish' }
    end
  end

  describe port 6082 do
    it { should be_listening }
    its('protocols') { should include 'tcp' }
    its('addresses') { should include '127.0.0.1' }
  end

  describe file '/etc/logrotate.d/varnishlog' do
    it { should exist }
    it { should be_file }
  end unless full_stack

  varnishadm_opts = '-S /etc/varnish/secret -T 127.0.0.1:6082'

  describe command "varnishadm #{varnishadm_opts} backend.list" do
    its('exit_status') { should eq 0 }
    if os_family == 'redhat' && os_release.start_with?('8.')
      its('stdout') { should match(%r{default\s+probe\s+[Hh]ealthy}) }
    else
      its('stdout') { should match(%r{default\s+healthy\s+0/0\s+[Hh]ealthy}) }
    end
  end

  describe command "varnishadm #{varnishadm_opts} param.show thread_pool_max" do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/Value is: 500 /) }
  end

  describe file '/var/log/varnish/varnishncsa.log' do
    its('content') { should match /ncsa_format_string_test/ }
  end if ncsa_format_string
end
