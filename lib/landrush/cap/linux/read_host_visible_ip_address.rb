module Landrush
  module Cap
    module Linux
      module ReadHostVisibleIpAddress
        #
        # !!!!!!!!!!!!
        # !!  NOTE  !!
        # !!!!!!!!!!!!
        #
        # This is a fragile heuristic: we are simply assuming the IP address of
        # the last interface non-localhost IP address is the host-visible one.
        #
        # For VMWare, the interface that Vagrant uses is host accessible, so we
        # expect this to be the same as `read_ip_address`.
        #
        # For VirtualBox, the Vagrant interface is not host visible, so we add
        # our own private_network, which we expect this to return for us.
        #
        # If the Vagrantfile sets up any sort of fancy networking, this has the
        # potential to fail, which will break things.
        #
        # TODO: Find a better heuristic for this implementation.
        #
        def self.read_host_visible_ip_address(machine)
          result = ""
          machine.communicate.execute(command) do |type, data|
            result << data if type == :stdout
          end

          last_line = result.chomp.split("\n").last || ''
          addresses = last_line.split(/\s+/).map { |address| IPAddr.new(address) }
          addresses = addresses.reject { |address| address.ipv6? }

          if addresses.empty?
            raise "Cannot detect IP address, command `#{command}` returned `#{result}`"
          end

          addresses.last.to_s
        end

        def self.command
          %Q(hostname -I 2>/dev/null || /sbin/ip ad | sed -ne 's/^\\W*inet \\([0-9.]*\\).* global .*$/\\1/p' 2>/dev/null)
        end
      end
    end
  end
end
