# -*- mode: puppet -*-
# vi: set ft=puppet :

# Node Definitions
node puppet.vagrant.localdomain {
  include role::puppetmaster::dev
}

node postgres.vagrant.localdomain {
  include role::postgresql::dev
}

node puppetdb.vagrant.localdomain {
  include role::puppetdb::dev
}

# Role Definitions
class role::puppetmaster::dev {
  include profile::puppetserver::dev
}

class role::puppet_pg::dev {
  include profile::postgresql::dev
}

class role::puppetdb::dev {
  include profile::puppetdb::dev
}

# Profile Definitions
class profile::puppetserver::dev {
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
