source 'https://rubygems.org'

# Can't use `gemspec` to pull in dependencies, because the landrush gem needs
# to be in the :plugins group for Vagrant to detect and load it in development

gem 'rubydns', '0.8.5'
gem 'rake'
gem 'json'

# Vagrant's special group
group :plugins do
  gem 'landrush', path: '.'
  gem 'landrush-ip', '~> 0.2.3'
end

group :test do
  gem 'rubocop', '~> 0.38.0'
end

group :development do
  gem 'vagrant',
      :git => 'git://github.com/mitchellh/vagrant.git',
      :ref => 'v1.8.1'

  gem 'byebug'
  gem 'mocha'
  gem 'minitest'
  gem 'cucumber', '~> 2.1'
  gem 'aruba', '~> 0.13'
  gem 'komenda', '~> 0.1.6'
end
