[Back to resource list](../README.md#resources)

# vcl_file

Create vcl file at `/etc/varnish/default.vcl` using the file at `files/default/default.vcl`:

## Actions

| Action         | Description                                                |
| -------------- | ---------------------------------------------------------- |
| `:configure`   | Creates a vcl file from the cookbook and refreshes varnish |
| `:unconfigure` | Removes the vcl file and refreshes varnish                 |

## Properties

| Name          | Type            | Default                              | Description                                                                                                                                      |
| ------------- | --------------- | ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| `vcl_name`    | String          | resource name                        | This will be the file name in the varnish vcl directory if not overridden by `vcl_path`                                                          |
| `source`      | String          | `::File.basename(vcl_name)"`         | Same behavior as the `cookbook_file` resource                                                                                                    |
| `cookbook`    | String          | `nil`                                | By default it uses the cookbook the resource is in                                                                                               |
| `owner`       | String          | `'root'`                             |                                                                                                                                                  |
| `group`       | String          | `'root'`                             |                                                                                                                                                  |
| `mode`        | String, Integer | `'0644'`                             | Follows the same behavior as the `cookbook_file` resource                                                                                        |
| `varnish_dir` | String          | `'/etc/varnish'`                     | The directory to use for vcl files                                                                                                               |
| `vcl_path`    | String          | `::File.join(varnish_dir, vcl_name)` | Overrides both the `vcl_name` and `varnish_dir` if this is specified                                                                             |

## Examples

```ruby
vcl_file 'default.vcl'
```
