# Migration Guide

## Breaking Change

This cookbook no longer ships cookbook-root recipes or node attributes. The former `varnish::configure` recipe and `node['varnish']` attribute tree have been replaced by the primary `varnish` custom resource and explicit resource properties.

## Recipe Migration

Before:

```ruby
node.override['varnish']['configure']['repo']['action'] = :nothing
node.override['varnish']['configure']['ncsa']['action'] = :configure

include_recipe 'varnish::configure'
```

After:

```ruby
varnish 'default' do
  repo_action :nothing
  ncsa_action :configure
  action :install
end
```

## Attribute Migration

Use properties on the `varnish` resource instead of attributes:

| Former attribute | New property |
| --- | --- |
| `node['varnish']['major_version']` | `major_version` |
| `node['varnish']['configure']['repo']['action']` | `repo_action` |
| `node['varnish']['configure']['package']['version']` | `package_version` |
| `node['varnish']['configure']['service']['action']` | `service_action` |
| `node['varnish']['configure']['config']['listen_port']` | `listen_port` |
| `node['varnish']['configure']['config']['storage']` | `storage` |
| `node['varnish']['configure']['vcl_template']['source']` | `vcl_source` |
| `node['varnish']['configure']['vcl_template']['cookbook']` | `vcl_cookbook` |
| `node['varnish']['configure']['vcl_template']['variables']` | `vcl_variables` |
| `node['varnish']['configure']['log']['action']` | `log_action` |
| `node['varnish']['configure']['ncsa']['action']` | `ncsa_action` |
| `node['varnish']['configure']['ncsa']['ncsa_format_string']` | `ncsa_format_string` |

The lower-level resources remain available for advanced workflows: `varnish_config`, `varnish_log`, `varnish_repo`, `vcl_file`, and `vcl_template`.

## Test Cookbook Examples

The migration test cookbook shows the supported patterns:

* `test/cookbooks/test/recipes/default.rb` installs the vendor-backed default stack.
* `test/cookbooks/test/recipes/distro.rb` skips the vendor repo and uses distro packages.
* `test/cookbooks/test/recipes/full_stack.rb` configures Varnish in front of nginx.
