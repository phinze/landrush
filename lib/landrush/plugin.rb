module Landrush
  class Plugin < Vagrant.plugin('2')
    name 'landrush'

    command 'landrush' do
      require_relative 'command'
      Command
    end

    config 'landrush' do
      require_relative 'config'
      Config
    end

    landrush_setup = lambda do |hook|
      require_relative 'action/common'
      require_relative 'action/setup'
      require_relative 'action/install_prerequisites'
      require_relative 'action/redirect_dns'

      hook.before(VagrantPlugins::ProviderVirtualBox::Action::Network, pre_boot_actions)
      hook.after(Vagrant::Action::Builtin::WaitForCommunicator, post_boot_actions)

      if defined?(VagrantPlugins::ProviderLibvirt)
        hook.after(VagrantPlugins::ProviderLibvirt::Action::CreateNetworks, pre_boot_actions)
        hook.after(VagrantPlugins::ProviderLibvirt::Action::WaitTillUp, post_boot_actions)
      end

      if defined?(HashiCorp::VagrantVMwarefusion)
        hook.before(HashiCorp::VagrantVMwarefusion::Action::Network, pre_boot_actions)
        hook.after(HashiCorp::VagrantVMwarefusion::Action::WaitForCommunicator, post_boot_actions)
      end

      if defined?(VagrantPlugins::Parallels)
        hook.before(VagrantPlugins::Parallels::Action::Network, pre_boot_actions)
      end
    end

    action_hook 'landrush_setup', :machine_action_up, &landrush_setup
    action_hook 'landrush_setup', :machine_action_reload, &landrush_setup

    def self.pre_boot_actions
      Vagrant::Action::Builder.new.tap do |b|
        b.use Action::Setup
        b.use Action::RedirectDns
      end
    end

    def self.post_boot_actions
      Vagrant::Action::Builder.new.tap do |b|
        b.use Action::InstallPrerequisites
      end
    end

    landrush_teardown = lambda do |hook|
      require_relative 'action/common'
      require_relative 'action/teardown'
      hook.after(Vagrant::Action::Builtin::GracefulHalt, Action::Teardown)
    end

    action_hook 'landrush_teardown', :machine_action_halt, &landrush_teardown
    action_hook 'landrush_teardown', :machine_action_destroy, &landrush_teardown
    action_hook 'landrush_teardown', :machine_action_reload, &landrush_teardown

    guest_capability('debian', 'iptables_installed') do
      require_relative 'cap/debian/iptables_installed'
      Cap::Debian::IptablesInstalled
    end

    guest_capability('debian', 'install_iptables') do
      require_relative 'cap/debian/install_iptables'
      Cap::Debian::InstallIptables
    end

    guest_capability('redhat', 'iptables_installed') do
      require_relative 'cap/redhat/iptables_installed'
      Cap::Redhat::IptablesInstalled
    end

    guest_capability('redhat', 'install_iptables') do
      require_relative 'cap/redhat/install_iptables'
      Cap::Redhat::InstallIptables
    end

    guest_capability('linux', 'configured_dns_servers') do
      require_relative 'cap/linux/configured_dns_servers'
      Cap::Linux::ConfiguredDnsServers
    end

    guest_capability('linux', 'redirect_dns') do
      require_relative 'cap/linux/redirect_dns'
      Cap::Linux::RedirectDns
    end

    guest_capability('linux', 'add_iptables_rule') do
      require_relative 'cap/linux/add_iptables_rule'
      Cap::Linux::AddIptablesRule
    end

    guest_capability('linux', 'read_host_visible_ip_address') do
      require_relative 'cap/all/read_host_visible_ip_address'
      Cap::All::ReadHostVisibleIpAddress
    end
  end
end
