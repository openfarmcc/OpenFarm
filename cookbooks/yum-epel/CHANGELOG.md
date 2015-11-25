yum-epel Cookbook CHANGELOG
======================
This file is used to list changes made in each version of the yum-epel cookbook.

v0.6.5 (2015-11-23)
-------------------
- Fix setting bool false properties

v0.6.4 (2015-10-27)
-------------------
- Updating default recipe for Chef 13 deprecation warnings. Not
  passing nil.

v0.6.3 (2015-09-22)
-------------------
- Added standard Chef gitignore and chefignore files
- Added the standard chef rubocop config
- Update contributing, maintainers, and testing docs
- Update Chefspec config to 4.X format
- Update distro versions in the Kitchen config
- Add Travis CI and cookbook version badges in the readme
- Expand the requirements section in the readme
- Add additional distros to the metadata
- Added source_url and issues_url metadata

v0.6.2 (2015-06-21)
-------------------
- Depending on yum ~> 3.2
- Support for the password attribute wasn't added to the
  yum_repository LWRP until yum 3.2.0.  

v0.6.1 (2015-06-21)
-------------------
- Switching to https for URL links
- Using metalink URLs

v0.6.0 (2015-01-03)
-------------------
- Adding EL7 support

v0.5.3 (2014-10-28)
-------------------
- Revert Use HTTPS for GPG keys and mirror lists

v0.5.2 (2014-10-28)
-------------------
- Use HTTPS for GPG keys and mirror lists
- Use local key on Amazon Linux

v0.5.0 (2014-09-02)
-------------------
- Add all attribute available to LWRP to allow for tuning.

v0.4.0 (2014-07-27)
-------------------
- [#9] Allowing list of repositories to reference configurable.

v0.3.6 (2014-04-09)
-------------------
- [COOK-4509] add RHEL7 support to yum-epel cookbook

v0.3.4 (2014-02-19)
-------------------
COOK-4353 - Fixing typo in readme

v0.3.2 (2014-02-13)
-------------------
Updating README to explain the 'managed' parameter

v0.3.0 (2014-02-12)
-------------------
[COOK-4292] - Do not manage secondary repos by default

v0.2.0
------
Adding Amazon Linux support

v0.1.6
------
Fixing up attribute values for EL6

v0.1.4
------
Adding CHANGELOG.md

v0.1.0
------
initial release
