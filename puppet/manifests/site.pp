# -*- mode: puppet -*-
# vi: set ft=puppet :
#
# Puppet definitions to quickly spin up a 3-node Vagrant dev lab
# Usage:
#
#     puppet apply --verbose --debug \
#                  --modulepath=/vagrant/modules \
#                  --manifestdir=/vagrant/manifests \
#                  /vagrant/manifests/site.pp
#
# Node Definitions
node "puppet.vagrant.localdomain" {
  include role::puppetmaster::dev
}

node "postgres.vagrant.localdomain" {
  include role::postgresql::dev
}

node "puppetdb.vagrant.localdomain" {
  include role::puppetdb::dev
}


# Role Definitions
class role {
  include profile::base
}

class role::puppetmaster inherits role {
  include profile::puppetserver
}

class role::puppetmaster::dev inherits role::puppetmaster {
  include profile::puppetserver::dev
}

class role::postgresql inherits role {
  include profile::postgresql
}

class role::postgresql::dev inherits role::postgresql {
  include profile::postgresql::dev
}

class role::puppetdb inherits role {
  include profile::puppetdb
}

class role::puppetdb::dev inherits role::puppetdb {
  include profile::puppetdb::dev
}


# Profile Definitions
class profile::base {

  anchor {'begin': }
  anchor {'end': }

  package {'puppetlabs-release':
    ensure   => installed,
    source   => 'http://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-7.noarch.rpm',
    provider => 'rpm',
  }

  package {['telnet','nc']:
    ensure => installed,
  }
}


class profile::puppetserver {

  include stdlib

  class {'puppetdb::master::config': }

  Anchor['begin'] ->
  Package['puppetlabs-release'] ->
  Class['puppetdb::master::config'] ->
  Anchor['end']
}


class profile::puppetserver::dev inherits profile::puppetserver {

  Class['puppetdb::master::config'] {
    puppetdb_server => 'puppetdb.vagrant.localdomain',
  }

  host {'puppetdb':
    ensure       => present,
    ip           => '192.168.10.11',
    name         => 'puppetdb.vagrant.localdomain',
    host_aliases => 'puppetdb',
  }

  host {'postgres':
    ensure       => present,
    ip           => '192.168.10.12',
    name         => 'postgres.vagrant.localdomain',
    host_aliases => 'postgres',
  }
}


class profile::postgresql {

  include stdlib

  class {'puppetdb::database::postgresql': }

  Anchor['begin'] ->
  Package['puppetlabs-release'] ->
  Class['puppetdb::database::postgresql'] ->
  Anchor['end']
}


class profile::postgresql::dev inherits profile::postgresql {

  Class['puppetdb::database::postgresql'] {
    listen_addresses => '0.0.0.0',
  }

  host {'puppet':
    ensure       => present,
    ip           => '192.168.10.10',
    name         => 'puppet.vagrant.localdomain',
    host_aliases => 'puppet',
  }

  host {'puppetdb':
    ensure       => present,
    ip           => '192.168.10.11',
    name         => 'puppetdb.vagrant.localdomain',
    host_aliases => 'puppetdb',
  }
}


class profile::puppetdb {
  include stdlib

  class {'puppetdb::server': }

  Anchor['begin'] ->
  Package['puppetlabs-release'] ->
  Class['puppetdb::server'] ->
  Anchor['end']
}


class profile::puppetdb::dev inherits profile::puppetdb {

  Class['puppetdb::server'] {
    database_host => 'postgres.vagrant.localdomain',
  }

  host {'puppet':
    ensure       => present,
    ip           => '192.168.10.10',
    name         => 'puppet.vagrant.localdomain',
    host_aliases => 'puppet',
  }

  host {'postgres':
    ensure       => present,
    ip           => '192.168.10.12',
    name         => 'postgres.vagrant.localdomain',
    host_aliases => 'postgres',
  }
}
