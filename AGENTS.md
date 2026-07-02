# AGENTS.md

## Agent Guidance

This cookbook uses `Policyfile.rb` for dependency resolution. Run `chef install Policyfile.rb`
after changing cookbook dependencies or test cookbook recipes, and keep Kitchen suites mapped to
Policyfile named run lists.

## Package Availability

### APT (Debian/Ubuntu)

The Varnish Cache project hosts official community packages on Packagecloud and recommends manual repository setup rather than the Packagecloud installer scripts.

* Ubuntu 20.04, 22.04, and 24.04 are documented by Varnish Software for Varnish Cache 6.0 LTS packages.
* Debian and Ubuntu distro packages are available through the native package manager, but distro versions may differ from Varnish Cache LTS.
* Packagecloud repository URLs use the pattern `https://packagecloud.io/varnishcache/varnish<major_without_dot>/<platform>/`.
* During local Dokken verification on May 7, 2026, `https://packagecloud.io/varnishcache/varnish60/ubuntu/ noble` returned 404 for the Ubuntu 24.04 arm64 container, so the required default suite uses distro packages.

### DNF/YUM (RHEL family)

The official Varnish documentation describes Packagecloud RPM repositories for Enterprise Linux. Varnish Cache 6.x package documentation explicitly covers EL 7 and EL 8. EL 9 compatible platforms may have distro packages, but this cookbook only treats Packagecloud availability as source-verified where upstream documents it.

* RHEL-family platforms need the stock `varnish` DNF module disabled on EL 8 and newer before installing Packagecloud packages.
* EPEL is still included for dependency compatibility on RHEL-family systems.
* Packagecloud repository URLs use the pattern `https://packagecloud.io/varnishcache/varnish<major_without_dot>/el/<major>/$basearch`.

### Zypper (SUSE)

No source-verified community Packagecloud support for openSUSE Leap was found for this cookbook migration, so openSUSE is not listed in `metadata.rb` or Kitchen.

## Architecture Limitations

Packagecloud repository paths are architecture-aware for RPMs through `$basearch`. The Varnish documentation consulted does not provide a complete per-release architecture matrix for community DEB/RPM repositories, so the cookbook does not claim architecture-specific support beyond what the upstream repositories publish.

## Source/Compiled Installation

This cookbook does not build Varnish from source. Upstream source builds require platform-specific build dependencies.

| Platform Family | Packages |
| --- | --- |
| Debian/Ubuntu | `make`, `automake`, `autotools-dev`, `libedit-dev`, `libjemalloc-dev`, `libncurses-dev`, `libpcre2-dev`, `libtool`, `pkg-config`, `python3-docutils`, `python3-sphinx`, `cpio` |
| RHEL/CentOS | `make`, `autoconf`, `automake`, `jemalloc-devel`, `libedit-devel`, `libtool`, `libunwind-devel`, `ncurses-devel`, `pcre2-devel`, `pkgconfig`, `python3-docutils`, `cpio` |

## Known Issues

* Varnish releases newer than 7.0 may need template and service flag updates before this cookbook can safely expose them as supported `major_version` values.
* Amazon Linux 2023 is not listed as supported. During local Dokken verification on May 7, 2026, `default-amazonlinux-2023` with distro packages failed with `No candidate version available for varnish`, and upstream Packagecloud documentation does not publish Amazon Linux 2023 repository support for this cookbook path.
* CentOS Stream is supported by platform family behavior and Kitchen coverage, but upstream community Packagecloud documentation is less explicit than for Ubuntu LTS and EL 8.
* The `full-stack` Kitchen suite is limited to Debian and Ubuntu in CI. On May 7, 2026, the AlmaLinux 8 full-stack job failed while restarting the distro `varnish` service after rendering a port-80 proxy configuration; default and distro coverage remains enabled for RHEL-family platforms, while the end-to-end proxy scenario is covered on Debian and Ubuntu.
