require 'bundler/setup'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'foodcritic'
require 'kitchen'
require 'berkshelf'
require 'fileutils'

# Style tests. Rubocop and Foodcritic
namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = { search_gems: true,
                  fail_tags: %w(correctness rackspace),
                  chef_version: '11.6.0'
                }
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

# Rspec and ChefSpec
desc 'Run ChefSpec unit tests'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = 'test/unit'
end

# Chef-client why run
desc 'Package Berkshelf'
task :berkspackage do
  unless File.directory?('/tmp/chef')
    FileUtils.mkdir '/tmp/chef'
  end

  if File.directory?('/tmp/chef/cookbooks')
    FileUtils.rm_r('/tmp/chef/cookbooks', force: true)
  end

  berksfile = Berkshelf::Berksfile.from_options(berksfile: 'Berksfile')
  berksfile.vendor('/tmp/chef/cookbooks')
  puts 'cd /tmp/chef; sudo chef-client --once --why-run --local-mode --override-runlist ...'
end

# Integration tests with test-kitchen (kitchen.ci)
desc 'Run Test Kitchen'
namespace :integration do
  Kitchen.logger = Kitchen.default_file_logger

  desc 'Run kitchen test with Vagrant'
  task :vagrant do
    Kitchen::Config.new.instances.each do |instance|
      instance.test(:always)
    end
  end

  %w(verify destroy).each do |t|
    desc "Run kitchen #{t} with cloud plugins"
    namespace :cloud do
      task t do
        @loader = Kitchen::Loader::YAML.new(local_config: '.kitchen.cloud.yml')
        config = Kitchen::Config.new(loader: @loader)
        concurrency = config.instances.size
        queue = Queue.new
        config.instances.each { |i| queue << i }
        concurrency.times { queue << nil }
        threads = []
        concurrency.times do
          threads << Thread.new do
            while instance = queue.pop
              instance.send(t)
            end
          end
        end
        threads.map(&:join)
      end
    end
  end

  task cloud: ['cloud:verify', 'cloud:destroy']
end

desc 'Run all tests on a CI Platform'
task ci: ['style', 'spec', 'integration:cloud']

# Default
task default: ['style', 'spec', 'integration:vagrant']
