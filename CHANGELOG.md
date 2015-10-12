varnish Cookbook CHANGELOG
==========================
This file is used to list changes made in each version of the varnish cookbook.

v2.3.0
------
- Fix chef 12.5 compatibility. This required a bunch of workarounds we should fix later.

v2.2.2
------

- #86 - Removed monkey patching of service providers

v2.2.1
-------------------
- Fix a bug in the monkey patched service resource, so that the changes needed for Varnish don't affect other services. #83.
- Update docs, Rakefile, standards. #79.
- Add additional examples to the documentation. #74.

v2.2.0
-------------------
- Fix default storage bug. Specify a default file storage location, as one is required with file backend, fixes #72. Adjust template for default configuration of varnish so that it won't do the file backend without a path, since that's illegal syntax.

- Cause varnish reload to happen after restart. Delayed notifications are queued up in order. In this case, it makes sense for the reload to happen after the restart.

- Switch from service restart to service reload. The varnish_default_vcl has been updated to perform a service reload instead of a service restart. This will prevent the cache from being cleared when a reload of the vcl file is enough.

v2.1.1
-------------------
- Fixes #56. The apt resource may not be included, so no need to run a notification on it.

v1.2.0
-------------------

- Make resource_name compatible with older Chef. Switch from passing an argument into resource_name to using the assignment operator '='. This will make resource_name compatible with older versions of Chef.

v1.1.0 (2015-02-16)
-------------------
- Created libraries, to eventually replace recipe functionality, currently can be used along side recipes
- Added CircleCI support for automated testing
- Added logrotate support
- Added varnish(log|nsca) support

v0.9.12 (2014-03-12)
--------------------
- [COOK-4368] - Improve documentation to include all attributes


v0.9.10
-------
### Bug
- **[COOK-3531](https://tickets.chef.io/browse/COOK-3531)** - Fix default instance name


v0.9.8
------
### Improvement
- **[COOK-3095](https://tickets.chef.io/browse/COOK-3095)** - Add MiniTest Chef Handler and Test Kitchen

v0.9.6
------
### Bug
- [COOK-2892]: Varnish restarts when vcl is updated instead of reloading

v0.9.4
------
- [COOK-1261] - fix issues with default.vcl handling

v0.9.0
------
- [COOK-873] - full daemon configuration through attributes
- [COOK-1091] - fix path for default.vcl, via COOK-873
- [COOK-1162] - add apt_repo recipe for using official varnish repository

v0.8.0
------
- Current public release.
