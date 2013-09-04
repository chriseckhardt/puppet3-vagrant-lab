# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define :postgres do |postgres|
    postgres.vm.box = "centos_6_3_x86_64"
    postgres.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
    postgres.vm.hostname = "postgres.vagrant.localdomain"
    postgres.vm.network :forwarded_port, guest: 22, host:2226, auto_correct: true
    postgres.vm.network :forwarded_port, guest: 5432, host: 5432
    postgres.vm.network :private_network, ip: "172.0.10.12"
  end

  config.vm.define :puppetdb do |puppetdb|
    puppetdb.vm.box = "centos_6_3_x86_64"
    puppetdb.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
    puppetdb.vm.hostname = "puppetdb.vagrant.localdomain"
    puppetdb.vm.network :forwarded_port, guest: 22, host:2225, auto_correct: true
    puppetdb.vm.network :forwarded_port, guest: 8081, host: 8081
    puppetdb.vm.network :private_network, ip: "172.0.10.11"
  end

  config.vm.define :puppetmaster do |puppet_server|
    puppet_server.vm.box = "centos_6_3_x86_64"
    puppet_server.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
    puppet_server.vm.hostname = "puppet.vagrant.localdomain"
    puppet_server.vm.network :forwarded_port, guest: 22, host:2224, auto_correct: true
    puppet_server.vm.network :forwarded_port, guest: 8140, host: 8140
    puppet_server.vm.network :private_network, ip: "172.0.10.10"
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "site.pp"
    puppet.modules_path = "modules"
    puppet.options = "--verbose --debug"
  end
end
