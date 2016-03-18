begin
  require 'vagrant'
rescue LoadError
  raise 'The Vagrant landrush plugin must be run within Vagrant.'
end

require 'pstore'

module Landrush
  def self.working_dir
    @working_dir ||= Pathname(File.expand_path('~/.vagrant.d/data/landrush')).tap(&:mkpath)
  end

  def self.working_dir=(working_dir)
    @working_dir = Pathname(working_dir).tap(&:mkpath)
  end

  def self.config
    @config ||= PStore.new(working_dir.join('config.pstore'))
  end
end

require 'rubydns'
require 'ipaddr'

require 'landrush/dependent_vms'
require 'landrush/plugin'
require 'landrush/resolver_config'
require 'landrush/server'
require 'landrush/store'
require 'landrush/version'

require 'ext/rexec'
