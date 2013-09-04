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

