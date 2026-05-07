# varnish_repo

[Back to resource list](../README.md#resources)

Configures the Varnish Packagecloud repository.

## Actions

| Action | Description |
| --- | --- |
| `:configure` | Configure the varnish repo |
| `:unconfigure` | Remove the varnish repo |

## Properties

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `major_version` | Float           | `6.0`   | Major version repository |
| `fetch_gpg_key` | `true`, `false` | `true`  | Fetch repository gpg key |

## Examples

```ruby
varnish_repo 'varnish' do
  major_version 6.6
end
```
