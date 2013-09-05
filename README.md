# djbkd/puppet3-vagrant-lab
This is a self-contained laboratory for hacking against Puppet 3.x with PuppetDB and PostgreSQL.
This uses the CentOS 6.4 vagrantbox provided by PuppetLabs


## Requirements
* Latest version of [Vagrant][vagrant]
* An Internet connection.

[vagrant]: http://vagrantup.com

## Usage

```bash
    git clone https://github.com/djbkd/puppet3-vagrant-lab.git
    cd puppet3-vagrant-lab/
    git submodule init
    git submodule update
    vagrant up
    vagrant ssh puppetmaster
```

There's a chicken/egg scenario where PuppetDB needs to acquire its SSL
certificate from the Puppet CA in order to fully configure itself.  Until I can
get a reasonable automation wrapped around it, I suggest doing the following:

1. Spin up the puppetmaster and start a puppetmaster process.
2. Spin up postgres.
3. Spin up puppetdb.
4. _vagrant ssh puppetdb_
5. Inside the puppetdb (as root):

```bash
    puppet agent --verbose --onetime --no-daemonize
```

6. Sign the new cert request on the _puppetmaster_.
7. On the _puppetdb_, run _puppetdb-ssl-setup_ to configure SSL.
8. Now you should be able to restart the puppetmaster process and have a fully
   working stack.


## Caveats
This is a work in progress and may not work at all.


## License

   Copyright 2013 Christopher W. Eckhardt

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

