# frozen_string_literal: true

version = input('version', value: 0)
ncsa_format_string = input('ncsa_format_string')
full_stack = input('full_stack')
os_family = os.family
os_release = os.release
os_name = os.name

control 'varnish-default-01' do
  impact 1.0
  title 'Varnish is installed and running'

  describe command 'varnishd -V' do
    its('exit_status') { should eq 0 }
    its('stderr') { should match(/varnish-#{version}/) } unless version == 0
  end

  describe service 'varnish' do
    it { should be_enabled }
    it { should be_running }
  end
end

control 'varnish-default-02' do
  impact 1.0
  title 'Varnish responds on the configured listener'

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

    describe command('sleep 2; curl -v localhost') do
      its('exit_status') { should eq 0 }
      its('stdout') { should match(/Hello World!/) }
      its('stderr') { should_not match(/Age: 0\s*/) }
      its('stderr') { should match(/Age: [0-9]+/) }
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
end

control 'varnish-default-03' do
  impact 0.7
  title 'Varnish administration and logging are configured'

  describe file '/etc/logrotate.d/varnishlog' do
    it { should exist }
    it { should be_file }
  end unless full_stack

  varnishadm_opts = '-S /etc/varnish/secret -T 127.0.0.1:6082'

  describe command "varnishadm #{varnishadm_opts} backend.list" do
    its('exit_status') { should eq 0 }
    if version.to_i >= 6
      its('stdout') { should match(%r{(?:reload_\d+_\d+_)?default\s+healthy\s+0/0\s+[Hh]ealthy}) }
    elsif version == 0 && os_family == 'redhat' && os_release.to_i == 7
      its('stdout') { should match(/default\(127.0.0.1,,8080\)\s+2\s+probe\s+Healthy/) }
    elsif version == 0 && os_name == 'debian' && os_release.to_i >= 11
      its('stdout') { should match(%r{(?:reload_\d+_\d+_)?default\s+healthy\s+0/0\s+[Hh]ealthy}) }
    elsif version == 0 && os_name == 'ubuntu' && os_release.to_f >= 20.04
      its('stdout') { should match(%r{(?:reload_\d+_\d+_)?default\s+healthy\s+0/0\s+[Hh]ealthy}) }
    else
      its('stdout') { should match(%r{(?:reload_\d+_\d+_)?default\s+(?:healthy\s+0/0|probe)\s+[Hh]ealthy}) }
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
