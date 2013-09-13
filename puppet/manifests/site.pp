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
  include profile::puppet::server
  include profile::mcollective::server
}

class role::puppetmaster::dev inherits role::puppetmaster {
  include profile::puppet::server::dev
  include profile::mcollective::server::dev
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
  include stdlib

  anchor {'begin': }
  anchor {'end': }

  package {['telnet','nc']:
    ensure => installed,
  }
}


class profile::puppet::server {}


class profile::puppet::server::dev inherits profile::puppet::server {

  class {'puppetdb::master::config':
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

  Anchor['begin'] ->
  Class['puppetdb::master::config'] ->
  Anchor['end']
}


class profile::mcollective::server {

}


class profile::mcollective::server::dev inherits profile::mcollective::server {

  class {'mcollective':
    version              => 'present',
    server               => true,
    server_config        => template('mcollective/server.cfg.erb'),
    server_config_file   => '/etc/mcollective/server.cfg',
    client               => false,
    client_config        => template('mcollective/client.cfg.erb'),
    client_config_file   => '/home/mcollective/.mcollective',
    stomp_server         => 'stomp',
    #mc_security_provider => 'XXX',
    #mc_security_psk      => 'mc_private_security_key',
  }

  class {'rabbitmq':
    # RabbitMQ clustering and H/A facilities
    # config_cluster    => true,
    # cluster_nodes     => ['rabbit1','rabbit2'],
    # RabbitMQ mirrored queues
    # http://www.rabbitmq.com/ha.html
    # config_mirrored_queues => true,
    service_manage    => true,
    config_stomp      => true,
    port              => '5672',
    delete_guest_user => true,
    environment_variables => {
      'RABBITMQ_NODENAME'    => 'node01',
      'RABBITMQ_SERVICENAME' => 'RabbitMQ'
    }
  }

  Anchor['begin'] ->
  Exec['install_epel'] ->
  Exec['import_rabbitmq_signing_key'] ->
  Class['rabbitmq'] ->
  Class['mcollective'] ->
  Anchor['end']
}


class profile::postgresql {}


class profile::postgresql::dev inherits profile::postgresql {
  class {'puppetdb::database::postgresql':
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

  Anchor['begin'] ->
  Class['puppetdb::database::postgresql'] ->
  Anchor['end']
}


class profile::puppetdb {}


class profile::puppetdb::dev inherits profile::puppetdb {

  class {'puppetdb::server':
    database_host      => 'postgres.vagrant.localdomain',
    ssl_listen_address => '0.0.0.0',
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

  Anchor['begin'] ->
  Host['postgres'] ->
  Class['puppetdb::server'] ->
  Anchor['end']
}
