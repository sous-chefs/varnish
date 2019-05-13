# varnish Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/varnish.svg)](https://supermarket.chef.io/cookbooks/varnish)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/varnish/master.svg)](https://circleci.com/gh/sous-chefs/varnish)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Configures varnish.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### chef-client

- Requires chef-client 12.15 and above.

### Platforms

Tested on the platforms below with distro installs and upstream Varnish packaging versions 3.0, 4.0, 4.1, 5, 5.1, 5.2, 6.0 and 6.1 unless otherwise noted.

| Varnish      |  3.0  |  4.0  |  4.1  |   5   |  5.1  |  5.2  |  6.0  |  6.1  | distro |
| ------------ | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :----: |
| CentOS 6     |   ✔   |   ✔   |   ✔   |   ✔   |   ✔   |   ✔   |   ✘   |   ✘   |   ✘    |
| CentOS 7     |   ✔   |   ✔   |   ✔   |   ✔   |   ✔   |   ✔   |   ✔   |   ✔   |   ✔    |
| Ubuntu 14.04 |   ✔   |   ✔   |   ✔   |   ✔   |   ✔   |   ✔   |   ✘   |   ✘   |   ✔    |
| Ubuntu 16.04 |   ✘   |   ✔   |   ✔   |   ✔   |   ✔   |   ✔   |   ✔   |   ✔   |   ✔    |

Other operating systems and Varnish versions may work, but are not explicitly tested or supported.

## Global Attributes

These attributes used as defaults for both resources and the `varnish::configure` cookbook but can be also overridden with other attributes and resource properties described later.

- `node['varnish']['conf_path']` - location of the `default` file that controls the varnish init script on Debian/Ubuntu systems.
- `node['varnish']['reload_cmd']` - location of the varnish reload script used by the systemd config file. This is not used for initd currently.
- `node['varnish']['conf_source']` - template file source to use for the `default` varnish init config.
- `node['varnish']['conf_cookbook']` - template cookbook source to use for the `default` varnish init config.
- `node['varnish']['major_version']` - the major version of varnish to install. Can be 3.0, 4.0, 4.1, 5, 5.1, 5.2, 6.0 or 6.1 and default's to 4.1.

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

| Resource                   | Attribute Namespace                            |
| -------------------------- | ---------------------------------------------- |
| `varnish_repo 'configure'` | `node['varnish']['configure']['repo']`         |
| `package 'varnish'`        | `node['varnish']['configure']['package']`      |
| `service 'varnish'`        | `node['varnish']['configure']['service']`      |
| `varnish_config 'default'` | `node['varnish']['configure']['config']`       |
| `vcl_template 'default'`   | `node['varnish']['configure']['vcl_template']` |
| `varnish_log 'default'`    | `node['varnish']['configure']['log']`          |
| `varnish_log 'ncsa'`       | `node['varnish']['configure']['ncsa']`         |

### Recipe Example's

Use the systems varnish package and skip enabling the varnishlog daemon :

```ruby
node.override['varnish']['configure']['repo']['action'] = :nothing
node.override['varnish']['configure']['log']['action'] = :nothing

include_recipe 'varnish::configure'
```

Use `custom.vcl.erb` template in `my_cookbook` and configure varnish to listen on port 80:

```ruby
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

#### varnish_repo - Properties

| Name            | Type                                                   | Default Value                                                              |
| --------------- | ------------------------------------------------------ | -------------------------------------------------------------------------- |
| `major_version` | `3.0`, `4.0`, `4.1`, `5`, `5.1`, `5.2`, `6.0` or `6.1` | `node['varnish']['major_version']` (4.1 by default)                        |
| `fetch_gpg_key` | `true` or `false`                                      | `true` for debian distro's otherwise `false` (rpm packages are not signed) |

#### varnish_repo - Actions

- `:configure` - Configures the varnish vendor repo.

#### Examples

Configures the varnish 3.0 vendor repo :

```ruby
varnish_repo 'varnish' do
  major_version 3.0
end
```

### varnish_config

Configures the Varnish service through the defaults or systemd init file. If you do not include this, the config files that come with your distro package will be used instead.

| Name                       | Type                                                   | Default Value                                                                   | Comment                                                                     |
| -------------------------- | ------------------------------------------------------ | ------------------------------------------------------------------------------- | --------------------------------------------------------------------------- |
| `conf`                     | `string`                                               | `node['varnish']['conf_source']`                                                | Defaults to `default.erb` or `default_systemd.erb` depending on init system |
| `start_on_boot`            | `true` or `false`                                      | `true`                                                                          | Currently only used for initd                                               |
| `max_open_files`           | integer                                                | `131_072`                                                                       |
| `max_locked_memory`        | integer                                                | `82_000`                                                                        |
| `major_version`            | `3.0`, `4.0`, `4.1`, `5`, `5.1`, `5.2`, `6.0` or `6.1` | `node['varnish']['major_version']`                                              | major_version attribute defaults to 4.1                                     |
| `instance_name`            | string                                                 | `` `hostname` ``                                                                |
| `listen_address`           | string                                                 | `nil`                                                                           |
| `listen_port`              | integer                                                | `6081`                                                                          |
| `secondary_listen_address` | string                                                 | `nil`                                                                           |
| `secondary_listen_port`    | integer                                                | `nil`                                                                           |
| `admin_listen_address`     | string                                                 | `'127.0.0.1'`                                                                   |
| `admin_listen_port`        | integer                                                | `6082`                                                                          |
| `user`                     | string                                                 | `'varnish'`                                                                     |
| `group`                    | string                                                 | `'varnish'`                                                                     | Only used on varnish versions before 4.1                                    |
| `ccgroup`                  | string                                                 | `nil`                                                                           | Only used on varnish 4.1                                                    |
| `ttl`                      | integer                                                | `120`                                                                           | Currently only used on initd systems                                        |
| `storage`                  | `'malloc'` or `'file'`                                 | `'file'`                                                                        |
| `file_storage_path`        | string                                                 | `'/var/lib/varnish/%s_storage.bin'` where %s is replaced with the resource name |
| `file_storage_size`        | string                                                 | `'1G'`                                                                          |
| `malloc_percent`           | Integer                                                | `33`                                                                            | Percent of total memory to allocate to malloc                               |
| `malloc_size`              | string                                                 | `nil`                                                                           | Size to allocate to malloc, a string like '500M'. Overrides malloc_percent. |
| `path_to_secret`           | string                                                 | `'/etc/varnish/secret'`                                                         |
| `reload_cmd`               | string                                                 | `node['varnish']['reload_cmd']`                                                 | Default to depends on system and is only needed for systemd currently.      |

You can also send a hash to `parameters` which will add additional parameters to the varnish daemon via the `-p` option. The default hash is:

```ruby
{ 'thread_pools' => '4',
  'thread_pool_min' => '5',
  'thread_pool_max' => '500',
  'thread_pool_timeout' => '300' }
```

#### varnish_config - Actions

- `:configure` - Creates the varnish configuration file from template.

#### varnish_config - Example

Configure some properties on the Varnish service :

```ruby
varnish_config 'default' do
  listen_address '0.0.0.0'
  listen_port 80
  storage 'malloc'
  malloc_percent 33
end
```

### vcl_template

| Name          | Type              | Default Value                        | Comment                                                                                                                                                                                 |
| ------------- | ----------------- | ------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `vcl_name`    | string            | resource name                        | This will be the file name in the varnish vcl directory if not overridden by `vcl_path`                                                                                                 |
| `source`      | string            | `"#{::File.basename(vcl_name)}.erb"` | Same behavior as the template resource. Default is the file name in vcl_name with '.erb' appended to it.                                                                                |
| `cookbook`    | string            | nil                                  | By default it uses the cookbook the resource is in.                                                                                                                                     |
| `owner`       | string            | `'root'`                             |
| `group`       | string            | `'root'`                             |
| `mode`        | string or integer | `'0644'`                             | Follows the same behavior as the template resource                                                                                                                                      |
| `variables`   | hash              | `{}`                                 | Same behavior as the template resource but if the installed varnish major version (3.0, 4.0, 4.1, 5, 5.1, 5.2, 6.0 or 6.1) can be found it is merged in at @varnish[:installed_version] |
| `varnish_dir` | string            | `'/etc/varnish'`                     | The directory to use for vcl files                                                                                                                                                      |
| `vcl_path`    | string            | `::File.join(varnish_dir, vcl_name)` | Overrides both the vcl_name and varnish_dir if this is specified.                                                                                                                       |

#### vcl_template - Example

Create vcl file at '/etc/varnish/backends.vcl' using the template at 'templates/default/backends.vcl.erb' and pass it some variables:

```ruby
vcl_template 'backends.vcl' do
  variables(
      backends_ids: Array(1..16),
      env: 'live',
  )
end
```

#### vcl_template - Actions

- `:configure` - Creates a vcl file from a template and refreshes varnish.
- `:unconfigure` - Removes the vcl file and refreshes varnish.

### vcl_file

| Name          | Type              | Default Value                        | Comment                                                                                 |
| ------------- | ----------------- | ------------------------------------ | --------------------------------------------------------------------------------------- |
| `vcl_name`    | string            | resource name                        | This will be the file name in the varnish vcl directory if not overridden by `vcl_path` |
| `source`      | string            | `::File.basename(vcl_name)"`         | Same behavior as the cookbook_file resource. Default is the file name in vcl_name.      |
| `cookbook`    | string            | nil                                  | By default it uses the cookbook the resource is in.                                     |
| `owner`       | string            | `'root'`                             |
| `group`       | string            | `'root'`                             |
| `mode`        | string or integer | `'0644'`                             | Follows the same behavior as the cookbook_file resource                                 |
| `varnish_dir` | string            | `'/etc/varnish'`                     | The directory to use for vcl files                                                      |
| `vcl_path`    | string            | `::File.join(varnish_dir, vcl_name)` | Overrides both the vcl_name and varnish_dir if this is specified.                       |

#### vcl_file - Example

Create vcl file at '/etc/varnish/default.vcl' using the file at 'files/default/default.vcl':

```ruby
vcl_file 'default.vcl'
```

#### vcl_file - Actions

- `:configure` - Creates a vcl file from the cookbook and refreshes varnish.
- `:unconfigure` - Removes the vcl file and refreshes varnish.

### varnish_log

Configures varnishlog or varnishncsa service. You can define both logfiles by calling `varnish_log` more than once. You can install logrotate config files if you wish as well.

| Name                 | Type                                                   | Default Value                                                                          | Comment                                                                  |
| -------------------- | ------------------------------------------------------ | -------------------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| `file_name`          | string                                                 | `'/var/log/varnish/varnishlog.log'`                                                    |
| `pid`                | string                                                 | `'/var/run/varnishlog.pid'`                                                            |
| `log_format`         | `'varnishlog'` or `'varnishncsa'`                      | `'varnishlog'`                                                                         |
| `ncsa_format_string` | string                                                 | `'%h \| %l \| %u \| %t \| \"%r\" \| %s \| %b \| \"%{Referer}i\" | \"%{User-agent}i\"'` |
| `instance_name`      | string                                                 | `nil`                                                                                  |
| `logrotate`          | `true` or `false`                                      | true for vanishlog, false for varnishncsa                                              |
| `major_version`      | `3.0`, `4.0`, `4.1`, `5`, `5.1`, `5.2`, `6.0` or `6.1` | currently installed major version                                                      | If varnish isn't installed yet then you will have to set this explicitly |
| `logrotate_path`     | `string`                                               | `'/etc/logrotate.d'` if varnishncsa is used otherwise `nil`                            |

#### varnish_log - Actions

- `:configure` - configures the `varnishlog` or `varnishncsa` service.

#### varnish_log - Examples

Configure varnishlog service :

```ruby
varnish_log 'default'
```

Configure varnishncsa service :

```ruby
varnish_log 'default_ncsa' do
  log_format 'varnishncsa'
end
```

### Resource Recipe Example

Install and configure varnish 4.1 using vcl config default.vcl in the current cookbook as well as a backend.vcl template.

```ruby
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

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
