# Landrush: DNS for Vagrant

Simple DNS that's visible on both the guest and the host.

> Because even a Vagrant needs a place to settle down once in a while.

Spins up a small DNS server and redirects DNS traffic from your VMs to use it,
automatically registers/deregisters IP addresseses of guests as they come up
and down.

## Installation

Install under Vagrant (1.1 or later):

    $ vagrant plugin install landrush

## Usage

Enable the plugin in your `Vagrantfile`:

    config.landrush.enable

Bring up a machine that has a private network IP address and a hostname (see the `Vagrantfile` for an example) 

    $ vagrant up

And you should be able to get your hostname from your host:

    $ dig -p 10053 @localhost myhost.vagrant.dev
    
If you shut down your guest, the entries associated with it will be removed.

You can add static host entries to the DNS server in your `Vagrantfile` like so:

    config.landrush.host 'myhost.example.com', '1.2.3.4'

Any DNS queries that do not match will be passed through to an upstream DNS server, so this will be able to serve as the one-stop shop for your guests' DNS needs.

### Visibility on the Guest

Linux guests using iptables should automatically have their DNS traffic redirected properly to our DNS server. File an issue if this does not work for you.

### Visibility on the Host

I'm currently developing this on OS X 10.8, and there's a nice trick you can pull to unobtrusibly add a secondary DNS server only for specific domains.

All you do is drop a file in `/etc/resolver/$DOMAIN` with information on how to connect to the DNS server you'd like to use for that domain.

So what I do is name all of my vagrant servers with the pattern `$host.vagrant.dev` and then drop a file called `/etc/resolver/vagrant.dev` with these contents:

```
# Use landrush server for this domain
nameserver 127.0.0.1
port 10053
```

Once you have done this, you can run `scutil --dns` to confirm that the DNS resolution is working -- you should see something like:
```
resolver #8
  domain   : vagrant.dev
  nameserver[0] : 127.0.0.1
  port     : 10053
```


This gives us automatic access to the landrush hosts without having to worry about it getting in the way of our normal DNS config.

## Work in Progress - Lots to do!

* The guest visibility strategy assumes iptables-based firewall.
* Lots of static values that need configurin' - config location, ports, etc.
* VirtualBox only right now, need to support VMWare
* Tests tests tests.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
