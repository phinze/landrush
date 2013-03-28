begin
  require 'vagrant'
rescue LoadError
  raise 'The Vagrant RubyDNS plugin must be run within Vagrant.'
end

require 'vagrant-rubydns/plugin'
require 'vagrant-rubydns/store'
require 'vagrant-rubydns/util'
require 'vagrant-rubydns/version'

module VagrantRubydns; end