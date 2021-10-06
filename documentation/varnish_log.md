[Back to resource list](../README.md#resources)

# varnish_log

Configures varnishlog or varnishncsa service. You can define both logfiles by calling `varnish_log` more than once. You can install logrotate config files if you wish as well.

## Actions

| Action         | Description                                          |
| -------------- | ---------------------------------------------------- |
| `:configure`   | configures the `varnishlog` or `varnishncsa` service |

## Properties

| Name                 | Type                              | Default                                                                                                      |
| -------------------- | --------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| `file_name`          | String                            | `'/var/log/varnish/varnishlog.log'`                                                                          |
| `pid`                | String                            | `'/var/run/varnishlog.pid'`                                                                                  |
| `log_format`         | `'varnishlog'` or `'varnishncsa'` | `'varnishlog'`                                                                                               |
| `ncsa_format_string` | String                            | `'%h \| %l \| %u \| %t \| \"%r\" \| %s \| %b \| \"%{Referer}i\" | \"%{User-agent}i\"'`                       |
| `instance_name`      | String                            | name property                                                                                                |
| `logrotate`          | `true`, `false`                   | `true` vanishlog, `false` for varnishncsa                                                                    |
| `major_version`      | Minor supported release           | Currently installed major version (If varnish isn't installed yet then you will have to set this explicitly) |
| `logrotate_path`     | String                            | `'/etc/logrotate.d'` if varnishncsa is used otherwise `nil`                                                  |

## Examples

```ruby
# Configure varnishlog service
varnish_log 'default'

# Configure varnishncsa service
varnish_log 'default_ncsa' do
  log_format 'varnishncsa'
end
```
