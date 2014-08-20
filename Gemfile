source 'https://rubygems.org'

group :lint do
  gem 'foodcritic', '~> 3.0'
  gem 'rubocop', '~> 0.24'
end

group :unit do
  # ChefSpec dependencies
  #
  # All gems loaded through the `chef_gem` resource should be included here
  # because ChefSpec never really converges these resources and thus the gems are
  # never installed during a Chef run. This makes all subsequent `requires` fail.
  #
  gem 'berkshelf', '~> 3'
  gem 'chefspec'
end

group :kitchen_common do
  gem 'test-kitchen'
end

group :kitchen_vagrant do
  gem 'kitchen-vagrant'
end

group :development do
  gem 'growl'
  gem 'rb-fsevent'
  gem 'fauxhai'
  gem 'pry-nav'
end
