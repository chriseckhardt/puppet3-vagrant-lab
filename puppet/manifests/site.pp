# -*- mode: puppet -*-
# vi: set ft=puppet :

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
class role::puppetmaster::dev {
  include profile::hosts::dev
  include profile::puppetserver::dev
}

class role::postgresql::dev {
  include profile::hosts::dev
  include profile::postgresql::dev
}

class role::puppetdb::dev {
  include profile::hosts::dev
  include profile::puppetdb::dev
}

# Profile Definitions
class profile::hosts::dev {
  host {'puppet':
    ensure       => present,
    ip           => '172.0.10.10',
    name         => 'puppet.vagrant.localdomain',
    host_aliases => 'puppet',
  }

  host {'puppetdb':
    ensure       => present,
    ip           => '172.0.10.11',
    name         => 'puppetdb.vagrant.localdomain',
    host_aliases => 'puppetdb',
  }

  host {'postgres':
    ensure       => present,
    ip           => '172.0.10.12',
    name         => 'postgres.vagrant.localdomain',
    host_aliases => 'postgres',
  }
}

class profile::puppetserver::dev {
  class {'puppetdb': }
  class {'puppetdb::master::config':
    puppetdb_server => 'puppetdb.vagrant.localdomain',
  }
}

class profile::postgresql::dev {
  class {'puppetdb::database::postgresql':
    listen_addresses => 'postgres.vagrant.localdomain',
  }
}

class profile::puppetdb::dev {
  class {'puppetdb::server':
    database_host => 'postgres.vagrant.localdomain',
  }
}
