[Back to resource list](../README.md#resources)

# varnish_repo

Configure's the varnish vendor repo.

## Actions

| Action       | Description                |
| ------------ | -------------------------- |
| `:configure` | Configure the varnish repo |

## Properties

| Name            | Type            | Default | Description              |
| --------------- | --------------- | ------- | ------------------------ |
| `major_version` | Float           | `7.0`   | Major version repository |
| `fetch_gpg_key` | `true`, `false` | `true`  | Fetch repository gpg key |

## Examples

```ruby
varnish_repo 'varnish' do
  major_version 6.6
end
```
