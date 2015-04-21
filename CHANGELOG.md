varnish Cookbook CHANGELOG
==========================
This file is used to list changes made in each version of the varnish cookbook.

v 2.1.1
----
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
