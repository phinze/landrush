module Landrush
  class Command < Vagrant.plugin('2', :command)
    DAEMON_COMMANDS = %w(start stop restart status)

    def self.synopsis
      "manages DNS for both guest and host"
    end

    def execute
      ARGV.shift # flush landrush from ARGV

      command = ARGV.first || 'help'
      if DAEMON_COMMANDS.include?(command)
        Server.send(command)
      elsif command == 'dependentvms' || command == 'vms'
        if DependentVMs.any?
          @env.ui.info(DependentVMs.list.map { |dvm| " - #{dvm}" }.join("\n"))
        else
          @env.ui.info("No dependent VMs")
        end
      elsif command == 'ls' || command == 'list'
        Landrush::Store.hosts.each do |key, value|
          printf "%-30s %s\n", key, value
        end
      elsif command == 'set'
        host, ip = ARGV[1,2]
        Landrush::Store.hosts.set(host, ip)
      elsif command == 'del' || command == 'rm'
        key = ARGV[1]
        Landrush::Store.hosts.delete(key)
      elsif command == 'help'
        @env.ui.info(help)
      else
        boom("'#{command}' is not a command")
      end

      0 # happy exit code
    end

    def boom(msg)
      raise Vagrant::Errors::CLIInvalidOptions, :help => usage(msg)
    end

    def usage(msg); <<-EOS.gsub(/^      /, '')
      ERROR: #{msg}

      #{help}
      EOS
    end

    def help; <<-EOS.gsub(/^      /, '')
      vagrant landrush <command>

      commands:
        {start|stop|restart|status}
          control the landrush server daemon
        list, ls
          list all DNS entries known to landrush
        dependentvms, vms
          list vms currently dependent on the landrush server
        set { <host> <ip> | <alias> <host> }
          adds the given host-to-ip or alias-to-hostname mapping.
          existing host ip addresses will be overwritten
        rm, del { <host> | <alias> }
          delete the given hostname or alias from the server
        help
          you're lookin at it!
      EOS
    end

  end
end
