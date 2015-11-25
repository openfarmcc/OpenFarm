git Cookbook CHANGELOG
======================
This file is used to list changes made in each version of the git cookbook.

v4.3.4 (2015-09-06)
-------------------
- Fixing package_id on OSX
- Adding 2.5.1 data for Windows

v4.3.3 (2015-07-27)
-------------------
- #76: Use checksum keyname instead of value in source recipe

v4.3.2 (2015-07-27)
-------------------
- Fixing up Windows provider (issue #73)
- Supporting changes to source_prefix in source provider (#62)

v4.3.1 (2015-07-23)
-------------------
- Fixing up osx_dmg_source_url

v4.3.0 (2015-07-20)
-------------------
- Removing references to node attributes from provider code
- Name-spacing of client resource property names
- Addition of windows recipe
- Creation of package recipe

v4.2.4 (2015-07-19)
-------------------
- Fixing source provider selection bug from 4.2.3

v4.2.3 (2015-07-18)
-------------------
- mac_os_x provider mapping
- various rubocops

v4.2.2 (2015-04-23)
-------------------
- Fix up action in Chef::Resource::GitService
- Adding matchers

v4.2.1 (2015-04-17)
-------------------
- Fixing Chef 11 support.
- Adding provider mapping file

v4.2.0 (2015-04-15)
-------------------
- Converting recipes to resources.
- Keeping recipe interface for backwards compat

v4.1.0 (2014-12-23)
-------------------
- Fixing windows package checksums
- Various test coverage additions

v4.0.2 (2014-04-23)
-------------------
- [COOK-4482] - Add FreeBSD support for installing git client

v4.0.0 (2014-03-18)
-------------------
- [COOK-4397] Only use_inline_resources on Chef 11


v3.1.0 (2014-03-12)
-------------------
- [COOK-4392] - Cleanup git_config LWRP


v3.0.0 (2014-02-28)
-------------------
[COOK-4387] Add git_config type
[COOK-4388] Fix up rubocops
[COOK-4390] Add integration tests for default and server suites


v2.10.0 (2014-02-25)
--------------------
- [COOK-4146] - wrong dependency in git::source for rhel 6
- [COOK-3947] - Git cookbook adds itself to the path every run


v2.9.0
------
Updating to depend on cookbook yum ~> 3
Fixing style to pass rubocop
Updating test scaffolding


v2.8.4
------
fixing metadata version error. locking to 3.0


v2.8.1
------
Locking yum dependency to '< 3'


v2.8.0
------
### Bug
- [COOK-3433] - git::server does not correctly set git-daemon's base-path on Debian


v2.7.0
------
### Bug
- **[COOK-3624](https://tickets.chef.io/browse/COOK-3624)** - Don't restart `xinetd` on each Chef client run
- **[COOK-3482](https://tickets.chef.io/browse/COOK-3482)** - Force git to add itself to the current process' PATH

### New Feature
- **[COOK-3223](https://tickets.chef.io/browse/COOK-3223)** - Support Omnios and SmartOS package installs

v2.6.0
------
### Improvement
- **[COOK-3193](https://tickets.chef.io/browse/COOK-3193)** - Add proper debian packages

v2.5.2
------
### Bug
- [COOK-2813]: Fix bad string interpolation in source recipe

v2.5.0
------
- Relax runit version constraint (now depend on 1.0+).

v2.4.0
------
- [COOK-2734] - update git versions

v2.3.0
------
- [COOK-2385] - update git::server for `runit_service` resource support

v2.2.0
------
- [COOK-2303] - git::server support for RHEL `platform_family`

v2.1.4
------
- [COOK-2110] - initial test-kitchen support (only available in GitHub repository)
- [COOK-2253] - pin runit dependency

v2.1.2
------
- [COOK-2043] - install git on ubuntu 12.04 not git-core

v2.1.0
------
The repository didn't have pushed commits, and so the following changes from earlier-than-latest versions wouldn't be available on the community site. We're releasing 2.1.0 to correct this.

- [COOK-1943] - Update to git 1.8.0
- [COOK-2020] - Add setup option attributes to Git Windows package install

v2.0.0
-------
This version uses `platform_family` attribute, making the cookbook incompatible with older versions of Chef/Ohai, hence the major version bump.

- [COOK-1668] - git cookbook fails to run due to bad `platform_family` call
- [COOK-1759] - git::source needs additional package for rhel `platform_family`

v1.1.2
------
- [COOK-2020] - Add setup option attributes to Git Windows package install

v1.1.0
------
- [COOK-1943] - Update to git 1.8.0

v1.0.2
------
- [COOK-1537] - add recipe for source installation

v1.0.0
------
- [COOK-1152] - Add support for Mac OS X
- [COOK-1112] - Add support for Windows

v0.10.0
-------
- [COOK-853] - Git client installation on CentOS

v0.9.0
------
- Current public release
