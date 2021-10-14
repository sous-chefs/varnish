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

- Requires chef-client 15.5 and above.

### Platforms

- CentOS 7+
- Debian 9+
- Ubuntu 18.04+

Other operating systems and Varnish versions may work, but are not explicitly tested or supported.

## Global Attributes

These attributes used as defaults for both resources and the `varnish::configure` cookbook but can be also overridden with other attributes and resource properties described later.

- `node['varnish']['conf_path']` - location of the `default` file that controls the varnish init script on Debian/Ubuntu systems.
- `node['varnish']['reload_cmd']` - location of the varnish reload script used by the systemd config file. This is not used for initd currently.
- `node['varnish']['conf_source']` - template file source to use for the `default` varnish init config.
- `node['varnish']['conf_cookbook']` - template cookbook source to use for the `default` varnish init config.
- `node['varnish']['major_version']` - the major version of varnish to install. Can be any valid major release. Defaults to 7.0.

## Recipes

### default

This is not used currently but reserved for minimal configuration needed for all the resources/recipes to work correctly.

### configure

Installs the varnish package, manages the varnish configuration file, and the init script defaults file.

## Usage

You can either use include the `varnish::configure` recipe and configure the setup using the recipe attributes described below or use the resources directly.

If running on a Redhat derivative then you may need to include yum-epel as it provides the jemalloc dependency that varnish needs.

## Configure Recipe Attributes

### Common Settings

The configure recipe uses the resources below to get varnish and varnishlog installed and running from the vendor repo. The recipe will work without any additional configuration however there is a few common attributes that you may want to set.

- `node['varnish']['configure']['repo']['action']` - Affects the vendor repo resource. Can be set to `:nothing` to skip and use the systems package otherwise the default is to `:configure` it.
- `node['varnish']['configure']['package']['version']` - Specific varnish version to pass to the package resource. Default is to install the latest available version for the current `node['varnish']['major_version']`.
- `node['varnish']['configure']['log']['action']` - Affects the `varnish_log` resource. Can be set to `:nothing` to skip and not set up logging otherwise the default is to `:configure` it.
- `node['varnish']['configure']['config']['listen_port']` - Port number to listen on for requests to varnish. Defaults to `6081`.
- `node['varnish']['configure']['vcl_template']['source']` - Name for default vcl template. Defaults to `default.vcl.erb`.
- `node['varnish']['configure']['vcl_template']['cookbook']` - Name of the cookbook for the default vcl template. Uses this varnish cookbook by default.

If you are using the default `vcl_template` then `backend_port` and `backend_host` are configurable through these parameters.

- `node['varnish']['configure']['vcl_template']['variables']['config']['backend_port']` - The default `vcl_template` `backend port` (default: `80`).
- `node['varnish']['configure']['vcl_template']['variables']['config']['backend_host']` - The default `vcl_template` `backend_host` (default: `127.0.0.1`).

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

The following resources are provided:

- [varnish_config](documentation/varnish_config.md)
- [varnish_log](documentation/varnish_log.md)
- [varnish_repo](documentation/varnish_repo.md)
- [vcl_file](documentation/vcl_file.md)
- [vcl_template](documentation/vcl_template.md)

### Resource Recipe Example

Install and configure varnish 6.6 using vcl config `default.vcl` in the current cookbook as well as a backend.vcl template.

```ruby
include_recipe 'varnish::default'

varnish_repo 'configure' do
  major_version 6.6
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
