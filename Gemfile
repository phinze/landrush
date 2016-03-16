source 'https://rubygems.org'

# Can't use `gemspec` to pull in dependencies, because the landrush gem needs
# to be in the :plugins group for Vagrant to detect and load it in development

gem 'rubydns', '1.0.2'
gem 'rexec'
gem 'rake'

# Vagrant's special group
group :plugins do
  gem 'landrush', path: '.'
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
end
