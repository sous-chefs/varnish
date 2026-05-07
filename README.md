# varnish Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/varnish.svg)](https://supermarket.chef.io/cookbooks/varnish)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Configures Varnish Cache with custom resources.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you'd like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Chef

Requires Chef Infra Client 15.3 and above.

### Platforms

See [LIMITATIONS.md](LIMITATIONS.md) for package availability and platform notes.

## Breaking Migration

This cookbook has migrated from recipes and node attributes to a full custom-resource API. See [migration.md](migration.md) before upgrading from a recipe-based release.

## Usage

The primary `varnish` resource installs the package, configures the service, renders the default VCL, and optionally configures logging.

```ruby
varnish 'default' do
  major_version 6.0
  ncsa_action :configure
  action :install
end
```

Use distro packages instead of the Varnish Packagecloud repository:

```ruby
varnish 'default' do
  repo_action :nothing
  ncsa_action :configure
  action :install
end
```

Configure Varnish to listen on port 80 with a custom VCL template:

```ruby
varnish 'default' do
  listen_port 80
  storage 'malloc'
  vcl_source 'custom.vcl.erb'
  vcl_cookbook 'my_cookbook'
  vcl_variables(
    config: {
      backend_host: '127.0.0.1',
      backend_port: '8080',
    }
  )
  action :install
end
```

## Resources

The following resources are provided:

* [varnish](documentation/varnish.md)
* [varnish_config](documentation/varnish_config.md)
* [varnish_log](documentation/varnish_log.md)
* [varnish_repo](documentation/varnish_repo.md)
* [vcl_file](documentation/vcl_file.md)
* [vcl_template](documentation/vcl_template.md)

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
