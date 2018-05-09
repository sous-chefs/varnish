# varnish Cookbook

[![Build Status](https://travis-ci.org/sous-chefs/varnish.svg?branch=master)](https://travis-ci.org/sous-chefs/varnish)  
[![Cookbook Version](https://img.shields.io/cookbook/v/varnish.svg)](https://supermarket.chef.io/cookbooks/varnish)

Configures varnish.

## Requirements

### chef-client

- Requires chef-client 12.9 and above.

### Platforms

Tested on the platforms below with distro installs and upstream Varnish packaging versions 3, 4.0, 4.1, and 5 unless otherwise noted.


* Ubuntu 14.04
* Ubuntu 16.04
  * Tested with Ubuntu's 16.04 distribution (version 4.1).
* CentOS 6.8
  * Tested with 3, 4.0, and 4.1 (distro version is 2.0 which is not supported) 
* CentOS 7.3
  * Tested with 4.1 and the CentOS 7 distrubution version
  * 4.0 only works with the distro version (https://github.com/sous-chefs/varnish/issues/142)

Other versions may work but require pinning to the correct version which isn't included in this cookbook currently.

## Global Attributes

These attributes used as defaults for both resources and the `varnish::configure` cookbook but can be also overridden with other attributes and resource properties described later.

- `node['varnish']['conf_path']` - location of the `default` file that controls the varnish init script on Debian/Ubuntu systems.
- `node['varnish']['reload_cmd']` - location of the varnish reload script used by the systemd config file. This is not used for initd currently.
- `node['varnish']['conf_source']` - template file source to use for the `default` varnish init config.
- `node['varnish']['conf_cookbook']` - template cookbook source to use for the `default` varnish init config.
- `node['varnish']['major_version']` - the major version of varnish to install. Can be 3.0, 4.0, 4.1, 5 and default's to 4.1.

## Recipes

### default

This is not used currently but reserved for minimal configuration needed for all the resources/recipes to work correctly.

### configure

Installs the varnish package, manages the varnish configuration file, and the init script defaults file.

## Usage

You can either use include the varnish::configure recipe and configure the setup using the recipe attributes described below or include varnish::default and use the resources directly.

If running on a Redhat derivative then you may need to include yum-epel as it provides the jemalloc dependency that varnish needs.

## Configure Recipe Attributes

### Common Settings

The configure recipe uses the resources below to get varnish and varnishlog installed and running from the vendor repo. The recipe will work without any additional configuration however there is a few common attributes that you may want to set.

- `node['varnish']['configure']['repo']['action']` - Affects the vendor repo resource. Can be set to `:nothing` to skip and use the systems package otherwise the default is to `:configure` it.
- `node['varnish']['configure']['package']['version']` - Specific varnish version to pass to the package resource. Default is to install the latest available version for the current `node['varnish']['major_version']`.
- `node['varnish']['configure']['log']['action']` - Affects the varnish_log resource. Can be set to `:nothing` to skip and not set up logging otherwise the default is to `:configure` it.
- `node['varnish']['configure']['config']['listen_port']` - Port number to listen on for requests to varnish. Defaults to 6081.
- `node['varnish']['configure']['vcl_template']['source']` - Name for default vcl template. Defaults to default.vcl.erb.
- `node['varnish']['configure']['vcl_template']['cookbook']` - Name of the cookbook for the default vcl template. Uses this varnish cookbook by default.

If you are using the default vcl_template then backend_port and backend_host are configurable through these parameters.

- `node['varnish']['configure']['vcl_template']['variables']['config']['backend_port']` - The default vcl_template backend port (default: 80).
- `node['varnish']['configure']['vcl_template']['variables']['config']['backend_host']` - The default vcl_template backend_host (default: 127.0.0.1).

Any resource property in the `varnish::configure` recipe can be configured. The keys under the namespace's listed below will map to the property name. Refer to the resource documentation for details on all the properties.

Resource                   | Attribute Namespace
-------------------------- | ----------------------------------------------
`varnish_repo 'configure'` | `node['varnish']['configure']['repo']`
`package 'varnish'`        | `node['varnish']['configure']['package']`
`service 'varnish'`        | `node['varnish']['configure']['service']`
`varnish_config 'default'` | `node['varnish']['configure']['config']`
`vcl_template 'default'`   | `node['varnish']['configure']['vcl_template']`
`varnish_log 'default'`    | `node['varnish']['configure']['log']`
`varnish_log 'ncsa'`       | `node['varnish']['configure']['ncsa']`

### Recipe Example's

Use the systems varnish package and skip enabling the varnishlog daemon :

```
node.override['varnish']['configure']['repo']['action'] = :nothing
node.override['varnish']['configure']['log']['action'] = :nothing

include_recipe 'varnish::configure'
```

Use `custom.vcl.erb` template in `my_cookbook` and configure varnish to listen on port 80:

```
node.override['varnish']['configure']['config']['listen_port'] = 80
node.override['varnish']['configure']['vcl_template']['source'] = 'custom.vcl.erb'
node.override['varnish']['configure']['vcl_template']['cookbook'] = 'my_cookbook'

include_recipe 'varnish::configure'
```

## Resources

See the example resource recipe section to see how to use these in your recipe.

### varnish_repo

Configure's the varnish vendor repo.

Will configure the varnish repo specified by `node['varnish']['major_version']` which can be overridden with the major_version property.

#### Properties

Name            | Type                       | Default Value
--------------- | -------------------------- | --------------------------------------------------------------------------
`major_version` | `3.0`, `4.0`, `4.1` or `5` | `node['varnish']['major_version']` (4.1 by default)
`fetch_gpg_key` | `true` or `false`          | `true` for debian distro's otherwise `false` (rpm packages are not signed)

#### Actions

- `:configure` - Configures the varnish vendor repo.

#### Examples

Configures the varnish 3.0 vendor repo :

```
varnish_repo 'varnish' do
  major_version 3.0
end
```

### varnish_config

Configures the Varnish service through the defaults or systemd init file. If you do not include this, the config files that come with your distro package will be used instead.

Name                   | Type                       | Default Value
---------------------- | -------------------------- | -------------------------------------------------------------------------------
`conf`                 | `string`                   | `node['varnish']['conf_source']`                                                | Defaults to `default.erb` or `default_systemd.erb` depending on init system
`start_on_boot`        | `true` or `false`          | `true`                                                                          | Currently only used for initd
`max_open_files`       | integer                    | `131_072`
`max_locked_memory`    | integer                    | `82_000`
`major_version`        | `3.0`, `4.0`, `4.1` or `5` | `node['varnish']['major_version']`                                              | major_version attribute defaults to 4.1
`instance_name`        | string                     | `` `hostname` `` ]`
`listen_address`       | string                     | `nil`
`listen_port`          | integer                    | `6081`
`admin_listen_address` | string                     | `'127.0.0.1'`
`admin_listen_port`    | integer                    | `6082`
`user`                 | string                     | `'varnish'`
`group`                | string                     | `'varnish'`                                                                     | Only used on varnish versions before 4.1
`ccgroup`              | string                     | `nil`                                                                           | Only used on varnish 4.1
`ttl`                  | integer                    | `120`                                                                           | Currently only used on initd systems
`storage`              | `'malloc'` or `'file'`     | `'file'`
`file_storage_path`    | string                     | `'/var/lib/varnish/%s_storage.bin'` where %s is replaced with the resource name
`file_storage_size`    | string                     | `'1G'`
`malloc_percent`       | Integer                    | `33`                                                                            | Percent of total memory to allocate to malloc
`malloc_size`          | string                     | `nil`                                                                           | Size to allocate to malloc, a string like '500M'. Overrides malloc_percent.
`path_to_secret`       | string                     | `'/etc/varnish/secret'`
`reload_cmd`           | string                     | `node['varnish']['reload_cmd']`                                                 | Default to depends on system and is only needed for systemd currently.

You can also send a hash to `parameters` which will add additional parameters to the varnish daemon via the `-p` option. The default hash is:

```
{ 'thread_pools' => '4',
  'thread_pool_min' => '5',
  'thread_pool_max' => '500',
  'thread_pool_timeout' => '300' }
```

#### Actions

- `:configure` - Creates the varnish configuration file from template.

#### Example

Configure some properties on the Varnish service :

```
varnish_config 'default' do
  listen_address '0.0.0.0'
  listen_port 80
  storage 'malloc'
  malloc_percent 33
end
```

### vcl_template

Name          | Type              | Default Value
------------- | ----------------- | ------------------------------------
`vcl_name`    | string            | resource name                        | This will be the file name in the varnish vcl directory if not overridden by `vcl_path`
`source`      | string            | `"#{::File.basename(vcl_name)}.erb"` | Same behavior as the template resource. Default is the file name in vcl_name with '.erb' appended to it.
`cookbook`    | string            | nil                                  | By default it uses the cookbook the resource is in.
`owner`       | string            | `'root'`
`group`       | string            | `'root'`
`mode`        | string or integer | `'0644'`                             | Follows the same behavior as the template resource
`variables`   | hash              | `{}`                                 | Same behavior as the template resource but if the installed varnish major version (3.0, 4.0, 4.1 or 5) can be found it is merged in at @varnish[:installed_version]
`varnish_dir` | string            | `'/etc/varnish'`                     | The directory to use for vcl files
`vcl_path`    | string            | `::File.join(varnish_dir, vcl_name)` | Overrides both the vcl_name and varnish_dir if this is specified.

#### Example

Create vcl file at '/etc/varnish/backends.vcl' using the template at 'templates/default/backends.vcl.erb' and pass it some variables:

```
vcl_template 'backends.vcl' do
  variables(
      backends_ids: Array(1..16),
      env: 'live',
  )
end
```

#### Actions

- `:configure` - Creates a vcl file from a template and refreshes varnish.
- `:unconfigure` - Removes the vcl file and refreshes varnish.

### vcl_file

Name          | Type              | Default Value
------------- | ----------------- | ------------------------------------
`vcl_name`    | string            | resource name                        | This will be the file name in the varnish vcl directory if not overridden by `vcl_path`
`source`      | string            | `::File.basename(vcl_name)"`         | Same behavior as the cookbook_file resource. Default is the file name in vcl_name.
`cookbook`    | string            | nil                                  | By default it uses the cookbook the resource is in.
`owner`       | string            | `'root'`
`group`       | string            | `'root'`
`mode`        | string or integer | `'0644'`                             | Follows the same behavior as the cookbook_file resource
`varnish_dir` | string            | `'/etc/varnish'`                     | The directory to use for vcl files
`vcl_path`    | string            | `::File.join(varnish_dir, vcl_name)` | Overrides both the vcl_name and varnish_dir if this is specified.

#### Example

Create vcl file at '/etc/varnish/default.vcl' using the file at 'files/default/default.vcl':

```
vcl_file 'default.vcl'
```

#### Actions

- `:configure` - Creates a vcl file from the cookbook and refreshes varnish.
- `:unconfigure` - Removes the vcl file and refreshes varnish.

### varnish_log

Configures varnishlog or varnishncsa service. You can define both logfiles by calling `varnish_log` more than once. You can install logrotate config files if you wish as well.

Name                 | Type                              | Default Value
-------------------- | --------------------------------- | -----------------------------------------------------------
`file_name`          | string                            | `'/var/log/varnish/varnishlog.log'`
`pid`                | string                            | `'/var/run/varnishlog.pid'`
`log_format`         | `'varnishlog'` or `'varnishncsa'` | `'varnishlog'`
`ncsa_format_string` | string                            | `'%h                                                        | %l | %u | %t | \"%r\" | %s | %b | \"%{Referer}i\" | \"%{User-agent}i\"'`
`instance_name`      | string                            | `nil`
`logrotate`          | `true` or `false`                 | true for vanishlog, false for varnishncsa
`major_version`      | `3.0`, `4.0`, `4.1`, or `5`       | currently installed major version                           | If varnish isn't installed yet then you will have to set this explicitly
`logrotate_path`     | `string`                          | `'/etc/logrotate.d'` if varnishncsa is used otherwise `nil`

#### Actions

- `:configure` - configures the `varnishlog` or `varnishncsa` service.

#### Examples

Configure varnishlog service :

```
varnish_log 'default'
```

Configure varnishncsa service :

```
varnish_log 'default_ncsa' do
  log_format 'varnishncsa'
end
```

### Resource Recipe Example

Install and configure varnish 4.1 using vcl config default.vcl in the current cookbook as well as a backend.vcl template.

```
include_recipe 'apt'
include_recipe 'varnish::default'

varnish_repo 'configure' do
  major_version 4.1
end

package 'varnish'

service 'varnish' do
  action [:enable, :start]
end

varnish_config 'default' do
  listen_address '0.0.0.0'
  listen_port 80
  storage 'malloc'
  malloc_percent 33
end

vcl_template 'backends.vcl' do
  source 'backends.vcl.erb'
  variables(
      backends_ids: Array(1..16),
      env: 'live',
  )
end

vcl_file 'default.vcl'

# varnishlog
varnish_log 'default'

# varnishncsa
varnish_log 'default_ncsa' do
  log_format 'varnishncsa'
end
```

License & Authors
-----------------
- Author:: Joe Williams <joe@joetify.com>
- Author:: Lew Goettner <lew@goettner.net>
- Author:: Matthew Thode <matt.thode@rackspace.com>
- Author:: Matt Barlow <matt.barlow@rackspace.com>
- Contributor:: Patrick Connolly <patrick@myplanetdigital.com>
- Contributor:: Antonio Fernández Vara <antoniofernandezvara@gmail.com>
- Contributor:: Ryan Gerstenkorn <ryan_gerstenkorn@fastmail.fm>

```text
Copyright 2008-2009, Joe Williams <joe@joetify.com>
Copyright 2014. Patrick Connolly <patrick@myplanetdigital.com>
Copyright 2015. Rackspace, US Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
