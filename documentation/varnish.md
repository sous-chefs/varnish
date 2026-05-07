# varnish

[Back to resource list](../README.md#resources)

Installs, configures, and manages the primary Varnish Cache stack.

## Actions

| Action | Description |
| --- | --- |
| `:install` | Installs and configures Varnish. Default. |
| `:remove` | Stops services and removes artifacts created by `:install`. |

## Properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `major_version` | Float | `6.0` | Varnish repository/config major version. |
| `repo_action` | Symbol, Array | `:configure` | Action passed to `varnish_repo`. |
| `package_action` | Symbol, Array | `:install` | Action passed to the package resource. |
| `package_name` | String | `'varnish'` | Package name. |
| `package_version` | String, nil | `nil` | Optional package version. |
| `service_action` | Symbol, Array | `[:enable, :start]` | Action passed to the Varnish service. |
| `service_name` | String | `'varnish'` | Service name. |
| `config_action` | Symbol, Array | `:configure` | Action passed to `varnish_config`. |
| `vcl_action` | Symbol, Array | `:configure` | Action passed to `vcl_template`. |
| `log_action` | Symbol, Array | `:configure` | Action passed to the `varnishlog` resource. |
| `ncsa_action` | Symbol, Array | `:nothing` | Action passed to the `varnishncsa` resource. |
| `ncsa_format_string` | String, nil | `nil` | Optional NCSA log format. |
| `vcl_source` | String | `'default.vcl.erb'` | VCL template source. |
| `vcl_cookbook` | String, nil | `'varnish'` | Cookbook for the VCL template. |
| `backend_host` | String | `'127.0.0.1'` | Backend host used by the default VCL variables. |
| `backend_port` | String | `'8080'` | Backend port used by the default VCL variables. |
| `vcl_variables` | Hash | backend host/port hash | Variables passed to `vcl_template`. |
| `listen_address` | String | `'0.0.0.0'` | Varnish listen address. |
| `listen_port` | Integer | `6081` | Varnish listen port. |
| `storage` | String | `'file'` | Storage backend, `file` or `malloc`. |
| `malloc_percent` | Integer, nil | `33` | Percentage of memory for malloc storage when `malloc_size` is unset. |
| `malloc_size` | String, nil | `nil` | Explicit malloc storage size. |
| `parameters` | Hash | thread pool defaults | Varnish daemon parameters passed with `-p`. |

## Examples

```ruby
varnish 'default' do
  ncsa_action :configure
  action :install
end
```

```ruby
varnish 'default' do
  repo_action :nothing
  listen_port 80
  storage 'malloc'
  action :install
end
```
