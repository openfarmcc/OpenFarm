windows Cookbook CHANGELOG
=======================
This file is used to list changes made in each version of the windows cookbook.

v1.38.4
--------------------
- [PR 295](https://github.com/chef-cookbooks/windows/pull/295) - Escape `http_acl` username
- [PR 293](https://github.com/chef-cookbooks/windows/pull/293) - Separating assignments to `code_script` and `guard_script` as they should be different scripts and not hold the same reference
- [Issue 298](https://github.com/chef-cookbooks/windows/issues/298) - `windows_certificate_binding` is ignoring `store_name` attribute and always saving to `MY`
- [Issue 296](https://github.com/chef-cookbooks/windows/pull/302) - Fixes `windows_certificate` idempotentcy on chef 11 clients

v1.38.3
--------------------
- Make `windows_task` resource idempotent (double quotes need to be single when comparing)
- [Issue 245](https://github.com/chef-cookbooks/windows/issues/256) - Fix `No resource, method, or local variable named `password' for `Chef::Provider::WindowsTask'` when `interactive_enabled` is `true`

v1.38.2
--------------------
- Lazy-load windows-pr gem library files. Chef 12.5 no longer includes the windows-pr gem. Earlier versions of this cookbook will not compile on Chef 12.5.

v1.38.1 (2015-07-28)
--------------------
- Publishing without extended metadata

v1.38.0 (2015-07-27)
--------------------
- Do not set new_resource.password to nil, Fixes #219, Fixes #220
- Add `windows_certificate` resource #212
- Add `windows_http_acl` resource #214

v1.37.0 (2015-05-14)
--------------------
- fix `windows_package` `Chef.set_resource_priority_array` warning
- update `windows_task` to support tasks in folders
- fix `windows_task` delete action
- replace `windows_task` name attribute with 'task_name'
- add :end action to 'windows_task'
- Tasks created with the `windows_task` resource default to the SYSTEM account
- The force attribute for `windows_task` makes the :create action update the definition.
- `windows_task` :create action will force an update of the task if the user or command differs from the currently configured setting.
- add default provider for `windows_feature`
- add a helper to make sure `WindowsRebootHandler` works in ChefSpec
- added a source and issues url to the metadata for Supermarket
- updated the Gemfile and .kitchen.yml to reflect the latest test-kitchen windows guest support
- started tests using the kitchen-pester verifier

v1.36.6 (2014-12-18)
--------------------
- reverting all chef_gem compile_time work

v1.36.5 (2014-12-18)
--------------------
- Fix zipfile provider

v1.36.4 (2014-12-18)
--------------------
- Fix Chef chef_gem with Chef::Resource::ChefGem.method_defined?(:compile_time)

v1.36.3 (2014-12-18)
--------------------
- Fix Chef chef_gem below 12.1.0

v1.36.2 (2014-12-17)
--------------------
- Being explicit about usage of the chef_gem's compile_time property.
- Eliminating future deprecation warnings in Chef 12.1.0

v1.36.1 (2014-12-17)
--------------------
- [PR 160](https://github.com/chef-cookbooks/windows/pull/160) - Fix Chef 11.10 / versions without windows_package in core

v1.36.0 (2014-12-16)
--------------------
- [PR 145](https://github.com/chef-cookbooks/windows/pull/145) - do not fail on non-existant task
- [PR 144](https://github.com/chef-cookbooks/windows/pull/144) - Add a zip example to the README
- [PR 110](https://github.com/chef-cookbooks/windows/pull/110) - More zip documentation
- [PR 148](https://github.com/chef-cookbooks/windows/pull/148) - Add an LWRP for font installation
- [PR 151](https://github.com/chef-cookbooks/windows/pull/151) - Fix windows_package on Chef 12, add integration tests
- [PR 129](https://github.com/chef-cookbooks/windows/pull/129) - Add enable/disable actions to task LWRP
- [PR 115](https://github.com/chef-cookbooks/windows/pull/115) - require Chef::Mixin::PowershellOut before using it
- [PR 88](https://github.com/chef-cookbooks/windows/pull/88) - Code 1003 from servermanagercmd.exe is valid

v1.34.8 (2014-10-31)
--------------------
- [Issue 137](https://github.com/chef-cookbooks/windows/issues/137) - windows_path resource breaks with ruby 2.x

v1.34.6 (2014-09-22)
--------------------
- [Chef-2009](https://github.com/chef/chef/issues/2009) - Patch to work around a regression in [Chef](https://github.com/chef/chef)

v1.34.2 (2014-08-12)
--------------------
- [Issue 99](https://github.com/chef-cookbooks/windows/issues/99) - Remove rubygems / Internet wmi-lite dependency (PR #108)

v1.34.0 (2014-08-04)
--------------------
- [Issue 99](https://github.com/chef-cookbooks/windows/issues/99) - Use wmi-lite to fix Chef 11.14.2 break in rdp-ruby-wmi dependency

v1.32.1 (2014-07-15)
--------------------
- Fixes broken cookbook release

v1.32.0 (2014-07-11)
--------------------
- Add ChefSpec resource methods to allow notification testing (@sneal)
- Add use_inline_resources to providers (@micgo)
- [COOK-4728] - Allow reboot handler to be used as an exception handler
- [COOK-4620] - Ensure win_friendly_path doesn't error out when ALT_SEPARATOR is nil

v1.31.0 (2014-05-07)
--------------------
- [COOK-2934] - Add windows_feature support for 2 new DISM attributes: all, source

v1.30.2 (2014-04-02)
--------------------
- [COOK-4414] - Adding ChefSpec matchers

v1.30.0 (2014-02-14)
--------------------
- [COOK-3715] - Unable to create a startup task with no login
- [COOK-4188] - Add powershell_version method to return Powershell version

v1.12.8 (2014-01-21)
--------------------
- [COOK-3988] Don't unescape URI before constructing it.

v1.12.6 (2014-01-03)
--------------------
- [COOK-4168] Circular dep on powershell - moving powershell libraries into windows. removing dependency on powershell

v1.12.4
-------
Fixing depend/depends typo in metadata.rb


v1.12.2
-------
### Bug
- **[COOK-4110](https://tickets.chef.io/browse/COOK-4110)** - feature_servermanager installed? method regex bug


v1.12.0
-------
### Bug
- **[COOK-3793](https://tickets.chef.io/browse/COOK-3793)** - parens inside parens of README.md don't render

### New Feature
- **[COOK-3714](https://tickets.chef.io/browse/COOK-3714)** - Powershell features provider and delete support.


v1.11.0
-------
### Improvement
- **[COOK-3724](https://tickets.chef.io/browse/COOK-3724)** - Rrecommend built-in resources over cookbook resources
- **[COOK-3515](https://tickets.chef.io/browse/COOK-3515)** - Remove unprofessional comment from library
- **[COOK-3455](https://tickets.chef.io/browse/COOK-3455)** - Add Windows Server 2012R2 to windows cookbook version helper

### Bug
- **[COOK-3542](https://tickets.chef.io/browse/COOK-3542)** - Fix an issue where `windows_zipfile` fails with LoadError
- **[COOK-3447](https://tickets.chef.io/browse/COOK-3447)** - Allow Overriding Of The Default Reboot Timeout In windows_reboot_handler
- **[COOK-3382](https://tickets.chef.io/browse/COOK-3382)** - Allow windows_task to create `on_logon` tasks
- **[COOK-2098](https://tickets.chef.io/browse/COOK-2098)** - Fix and issue where the `windows_reboot` handler is ignoring the reboot time

### New Feature
- **[COOK-3458](https://tickets.chef.io/browse/COOK-3458)** - Add support for `start_date` and `start_time` in `windows_task`


v1.10.0
-------
### Improvement

- [COOK-3126]: `windows_task` should support the on start frequency
- [COOK-3127]: Support the force option on task create and delete

v1.9.0
------
### Bug

- [COOK-2899]: windows_feature fails when a feature install requires a
  reboot
- [COOK-2914]: Foodcritic failures in Cookbooks
- [COOK-2983]: windows cookbook has foodcritic failures

### Improvement

- [COOK-2686]: Add Windows Server 2012 to version.rb so other
  depending chef scripts can detect Windows Server 2012

v1.8.10
-------
When using Windows qualified filepaths (C:/foo), the #absolute? method
for URI returns true, because "C" is the scheme.

This change checks that the URI is http or https scheme, so it can be
passed off to remote_file appropriately.

* [COOK-2729] - allow only http, https URI schemes

v1.8.8
------
* [COOK-2729] - helper should use URI rather than regex and bare string

v1.8.6
------
* [COOK-968] - `windows_package` provider should gracefully handle paths with spaces
* [COOK-222] - `windows_task` resource does not declare :change action
* [COOK-241] - Windows cookbook should check for redefined constants
* [COOK-248] - Windows package install type is case sensitive

v1.8.4
------
* [COOK-2336] - MSI That requires reboot returns with RC 3010 and
  causes chef run failure
* [COOK-2368] - `version` attribute of the `windows_package` provider
  should be documented

v1.8.2
------
**Important**: Use powershell in nodes expanded run lists to ensure
  powershell is downloaded, as powershell has a dependency on this
  cookbook; v1.8.0 created a circular dependency.

* [COOK-2301] - windows 1.8.0 has circular dependency on powershell

v1.8.0
------
* [COOK-2126] - Add checksum attribute to `windows_zipfile`
* [COOK-2142] - Add printer and `printer_port` LWRPs
* [COOK-2149] - Chef::Log.debug Windows Package command line
* [COOK-2155] -`windows_package` does not send checksum to
  `cached_file` in `installer_type`

v1.7.0
------
* [COOK-1745] - allow for newer versions of rubyzip

v1.6.0
------
* [COOK-2048] - undefined method for Falseclass on task :change when
  action is :nothing (and task doesn't exist)
* [COOK-2049] - Add `windows_pagefile` resource

v1.5.0
------
* [COOK-1251] - Fix LWRP "NotImplementedError"
* [COOK-1921] - Task LWRP will return true for resource exists when no
  other scheduled tasks exist
* [COOK-1932] - Include :change functionality to windows task lwrp

v1.4.0:
------
* [COOK-1571] - `windows_package` resource (with msi provider) does not
accept spaces in filename
* [COOK-1581] - Windows cookbook needs a scheduled tasks LWRP
* [COOK-1584] - `windows_registry` should support all registry types

v1.3.4
------
* [COOK-1173] - `windows_registry` throws Win32::Registry::Error for
  action :remove on a nonexistent key
* [COOK-1182] - windows package sets start window title instead of
  quoting a path
* [COOK-1476] - zipfile lwrp should support :zip action
* [COOK-1485] - package resource fails to perform install correctly
  when "source" contains quote
* [COOK-1519] - add action :remove for path lwrp

v1.3.2
------
* [COOK-1033] - remove the `libraries/ruby_19_patches.rb` file which
  causes havoc on non-Windows systems.
* [COOK-811] - add a timeout parameter attribute for `windows_package`

v1.3.0
------
* [COOK-1323] - Update for changes in Chef 0.10.10.
  - Setting file mode doesn't make sense on Windows (package provider
  - and `reboot_handler` recipe)
  - Prefix ::Win32 to avoid namespace collision with Chef::Win32
  - (`registry_helper` library)
  - Use chef_gem instead of gem_package so gems get installed correctly
    under the Ruby environment Chef runs in (reboot_handler recipe,
    zipfile provider)

v1.2.12
-------
* [COOK-1037] - specify version for rubyzip gem
* [COOK-1007] - `windows_feature` does not work to remove features with
  dism
* [COOK-667] - shortcut resource + provider for Windows platforms

v1.2.10
-------
* [COOK-939] - add `type` parameter to `windows_registry` to allow binary registry keys.
* [COOK-940] - refactor logic so multiple values get created.

v1.2.8
------
* FIX: Older Windows (Windows Server 2003) sometimes return 127 on successful forked commands
* FIX: `windows_package`, ensure we pass the WOW* registry redirection flags into reg.open

v1.2.6
------
* patch to fix [CHEF-2684], Open4 is named Open3 in Ruby 1.9
* Ruby 1.9's Open3 returns 0 and 42 for successful commands
* retry keyword can only be used in a rescue block in Ruby 1.9

v1.2.4
------
* `windows_package` - catch Win32::Registry::Error that pops up when searching certain keys

v1.2.2
------
* combined numerous helper libarires for easier sharing across libaries/LWRPs
* renamed Chef::Provider::WindowsFeature::Base file to the more descriptive `feature_base.rb`
* refactored `windows_path` LWRP
  * :add action should MODIFY the the underlying ENV variable (vs CREATE)
  * deleted greedy :remove action until it could be made more idempotent
* added a `windows_batch` resource/provider for running batch scripts remotely

v1.2.0
------
* [COOK-745] gracefully handle required server restarts on Windows platform
  * WindowsRebootHandler for requested and pending reboots
  * `windows_reboot` LWRP for requesting (receiving notifies) reboots
  * `reboot_handler` recipe for enabling WindowsRebootHandler as a report handler
* [COOK-714] Correct initialize misspelling
* RegistryHelper - new `get_values` method which returns all values for a particular key.

v1.0.8
------
* [COOK-719] resource/provider for managing windows features
* [COOK-717] remove `windows_env_vars` resource as env resource exists in core chef
* new `Windows::Version` helper class
* refactored `Windows::Helper` mixin

v1.0.6
------
* added `force_modify` action to `windows_registry` resource
* add `win_friendly_path` helper
* re-purpose default recipe to install useful supporting windows related gems

v1.0.4
------
* [COOK-700] new resources and improvements to the `windows_registry` provider (thanks Paul Morton!)
  * Open the registry in the bitednes of the OS
  * Provide convenience methods to check if keys and values exit
  * Provide convenience method for reading registry values
  * NEW - `windows_auto_run` resource/provider
  * NEW - `windows_env_vars` resource/provider
  * NEW - `windows_path` resource/provider
* re-write of the `windows_package` logic for determining current installed packages
* new checksum attribute for `windows_package` resource...useful for remote packages

v1.0.2
------
* [COOK-647] account for Wow6432Node registry redirecter
* [COOK-656] begin/rescue on win32/registry

v1.0.0
------
* [COOK-612] initial release
