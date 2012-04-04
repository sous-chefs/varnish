Description
===========

Installs and configures varnish.

Requirements
============

## Platform:

Tested on:

* Ubuntu 11.10
* Ubuntu 10.04
* Debian 6.0

Attributes
==========

* `node['varnish']['dir']` - location of the varnish configuration
  directory
* `node['varnish']['default']` - location of the `default` file that
  controls the varnish init script on Debian/Ubuntu systems.
* `node['varnish']['start']` - Should we start varnishd at boot?  Set to "no" to disable (yes)
* `node['varnish']['nfiles']` -  Open files (131072)
* `node['varnish']['memlock']` -  Maxiumum locked memory size for shared memory log (82000)
* `node['varnish']['instance']` - Default varnish instance name (node['fqdn'])
* `node['varnish']['listen_address']` -  Default address to bind to. Blank address (the default) means all IPv4 and IPv6 interfaces, otherwise specify a host name, an IPv4 dotted quad, or an IPv6 address in brackets
* `node['varnish']['listen_port']` - Default port to listen on (6081)
* `node['varnish']['vcl_conf']` - Main configuration file. (default.vcl)
* `node['varnish']['secret_file']` - 
* `node['varnish']['admin_listen_address']` - Telnet admin interface listen address (127.0.0.1)
* `node['varnish']['admin_listen_port']` - Telnet admin interface listen port (6082)
* `node['varnish']['user']` - Specifies the name of an unprivileged user to which the child process should switch before it starts  accepting  connections (varnish)
* `node['varnish']['group']` - Specifies  the name of an unprivileged group to which the child process should switch before it starts accepting connections (varnish)
* `node['varnish']['ttl']` - Specifies  a hard minimum time to live for cached documents. (120)
* `node['varnish']['min_threads']` - Start at least this many threads (5)
* `node['varnish']['max_threads']` - Start no more then this max amount of threads (500)
* `node['varnish']['thread_timeout']` - Thread idle timeout (300)
* `node['varnish']['storage']` -  = 'file'
* `node['varnish']['storage_file']` -  = '/var/lib/varnish/$INSTANCE/varnish_storage.bin'
* `node['varnish']['storage_size']` -  = '1G'

Recipes
=======

default
-------

Installs the varnish package, manages the default varnish
configuration file, and the init script defaults file.

Usage
=====

On systems that need a high performance caching server, use
`recipe[varnish]`. Additional configuration can be done by modifying
the `default.vcl.erb` and `ubuntu-default.erb` templates. By default
the `custom-default.erb` is set up to run with the varnish defaults, and 
a simple `default.vcl`.

License and Author
==================

Author:: Joe Williams <joe@joetify.com>   Author:: Lew Goettner <lew@goettner.net>

Copyright:: 2008-2009, Joe Williams

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
