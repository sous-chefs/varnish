require 'rspec/expectations'
require 'chefspec'
require 'chefspec/berkshelf'
require 'chef/application'

at_exit { ChefSpec::Coverage.report! }

::LOG_LEVEL = :fatal
::UBUNTU_OPTS = {
  platform: 'ubuntu',
  version: '12.04',
  log_level: ::LOG_LEVEL
}
::CHEFSPEC_OPTS = {
  log_level: ::LOG_LEVEL
}

def node_resources(node)
  node.set['memory']['total'] = '100000Kb'
end

def stub_resources
  shellout = double
  allow(Mixlib::ShellOut).to receive(:new).with('varnishd -V 2>&1').and_return(shellout)
  allow(shellout).to receive(:run_command).and_return(shellout)
  allow(shellout).to receive(:error!).and_return(true)
  allow(shellout).to receive(:stdout).and_return('varnish-4.0')
  allow(shellout).to receive(:environment).and_return('/root')
  allow(shellout.environment).to receive(:[]=).and_return('/root')
  allow(shellout.stdout).to receive(:match).and_return(true)
  allow(shellout.stdout.match).to receive(:captures).and_return(true)
  allow(shellout.stdout.match.captures).to receive(:[]).and_return(true)
end

at_exit { ChefSpec::Coverage.report! }
