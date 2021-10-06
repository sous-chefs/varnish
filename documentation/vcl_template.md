[Back to resource list](../README.md#resources)

# vcl_template

Create vcl file at `/etc/varnish/backends.vcl` using the template at `templates/default/backends.vcl.erb` and pass it some variables:

## Actions

| Action         | Description                                              |
| -------------- | -------------------------------------------------------- |
| `:configure`   | Creates a vcl file from a template and refreshes varnish |
| `:unconfigure` | Removes the vcl file and refreshes varnish               |

## Properties

| Name          | Type            | Default                              | Description                                                                                                                                      |
| ------------- | --------------- | ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| `vcl_name`    | String          | resource name                        | This will be the file name in the varnish vcl directory if not overridden by `vcl_path`                                                          |
| `source`      | String          | `"#{::File.basename(vcl_name)}.erb"` | Same behavior as the template resource                                                                                                           |
| `cookbook`    | String          | `nil`                                | By default it uses the cookbook the resource is in                                                                                               |
| `owner`       | String          | `'root'`                             |                                                                                                                                                  |
| `group`       | String          | `'root'`                             |                                                                                                                                                  |
| `mode`        | String, Integer | `'0644'`                             | Follows the same behavior as the template resource                                                                                               |
| `variables`   | Hash            | `{}`                                 | Same behavior as the template resource but if the installed varnish major version can be found it is merged in at `@varnish[:installed_version]` |
| `varnish_dir` | String          | `'/etc/varnish'`                     | The directory to use for vcl files                                                                                                               |
| `vcl_path`    | String          | `::File.join(varnish_dir, vcl_name)` | Overrides both the `vcl_name` and `varnish_dir` if this is specified                                                                             |

## Examples

```ruby
vcl_template 'backends.vcl' do
  variables(
    backends_ids: Array(1..16),
    env: 'live',
  )
end
```
