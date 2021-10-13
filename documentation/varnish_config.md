[Back to resource list](../README.md#resources)

# varnish_config

Configures the Varnish service through the defaults or systemd init file. If you do not include this, the config files that come with your distro package will be used instead.

## Actions

| Action       | Description                                          |
| ------------ | ---------------------------------------------------- |
| `:configure` | Creates the varnish configuration file from template |

## Properties

| Name                       | Type                    | Default                             |
| -------------------------- | ----------------------- | ----------------------------------- |
| `conf_source`              | String                  | `default_systemd.erb`               |
| `max_open_files`           | Integer                 | `131_072`                           |
| `max_locked_memory`        | Integer                 | `82_000`                            |
| `major_version`            | Minor supported release | `node['varnish']['major_version']`  |
| `instance_name`            | String                  | Node hostname                    |
| `listen_address`           | String                  | `nil`                               |
| `listen_port`              | Integer                 | `6081`                              |
| `secondary_listen_address` | String                  | `nil`                               |
| `secondary_listen_port`    | Integer                 | `nil`                               |
| `admin_listen_address`     | String                  | `'127.0.0.1'`                       |
| `admin_listen_port`        | Integer                 | `6082`                              |
| `storage`                  | `'malloc'` or `'file'`  | `'file'`                            |
| `file_storage_path`        | String                  | `'/var/lib/varnish/%s_storage.bin'` |
| `file_storage_size`        | String                  | `'1G'`                              |
| `malloc_percent`           | Integer                 | `33`                                |
| `malloc_size`              | String                  | `nil`                               |
| `path_to_secret`           | String                  | `'/etc/varnish/secret'`             |
| `reload_cmd`               | String                  | `node['varnish']['reload_cmd']`     |

You can also send a hash to `parameters` which will add additional parameters to the varnish daemon via the `-p` option. The default hash is:

```ruby
{
  'thread_pools' => '4',
  'thread_pool_min' => '5',
  'thread_pool_max' => '500',
  'thread_pool_timeout' => '300'
}
```

## Examples

```ruby
varnish_config 'default' do
  listen_address '0.0.0.0'
  listen_port 80
  storage 'malloc'
  malloc_percent 33
end
```
