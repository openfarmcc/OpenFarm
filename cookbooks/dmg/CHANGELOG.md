dmg Cookbook CHANGELOG
======================
This file is used to list changes made in each version of the dmg cookbook.

v2.3.0 (2015-10-20)
-------------------
* Add new headers property to the LWRP for custom http headers.  See the readme for more information
* Removed pivotal tracker example in the readme
* Added travis and cookbook version badges to the readme
* Added a .foodcritic file to exclude rules
* Updated chefignore and .gitignore files
* Updated platforms in Test Kitchen
* Added standard Rubocop file
* Updated Travis to test using ChefDK for the latest deps
* Added a Berksfile
* Updated contributing and testing docs
* Updated Gemfile with the latest testing deps
* Added maintainers.md and maintainers.toml
* Added rakefile for simplified testing
* Added source_url and issues_url metadata
* Added basic converge chefspec

v2.2.2 (2014-11-12)
-------------------
- #23, add chefspec matchers

v2.2.0 (2014-02-25)
-------------------
- [COOK-4285] Accept long EULAs


v2.1.4 (2014-01-26)
-------------------
* [COOK-4157] - dmg_package LWRP broken due to "puts" instead of "system"
* [COOK-4065] - dmg cookbook outputs the name of packages when checking if they are installed


v2.1.2
------
Cleaning up merge errors


v2.1.0
------
### Bug
- **[COOK-3946](https://tickets.chef.io/browse/COOK-3946)** - Syntax error in resources/package.rb
- **[COOK-2672](https://tickets.chef.io/browse/COOK-2672)** - EULA for package is displayed instead accepted


v2.0.8
------
Adding a Chef 10 compatibility check in provider


v2.0.6
------
# BUG
- [COOK-3302] - Sometimes hdiutil detach fails due to cfprefsd running in background
# IMPROVEMENT
- Adding foodcritic and rubocop to .travis.yml


v2.0.4
------
### Bug
- **[COOK-3331](https://tickets.chef.io/browse/COOK-3331)** - Fix an issue where `dmg_package` with no source raises an exception


v2.0.2
------
### Bug
- **[COOK-3578](https://tickets.chef.io/browse/COOK-3578)** - Support `package_id`s with spaces
- **[COOK-3302](https://tickets.chef.io/browse/COOK-3302)** - Fix an issue where `hdiutil detach` fails due to `cfprefsd` running in the background

v2.0.0
------
### Bug
- **[COOK-3389](https://tickets.chef.io/browse/COOK-3389)** - Use `rsync` instead of `cp` (potentially a breaking change on some systems)

v1.1.0
------
- [COOK-1847] - accept owner parameter for installing packages

v1.0.0
------
- [COOK-852] - Support "pkg" in addition to "mpkg" package types

v0.7.0
------
- [COOK-854] - use `cp -R` instead of `cp -r`
- [COOK-855] - specify a file or directory to check for prior install

v0.6.0
------
- option to install software that is an .mpkg inside a .dmg
- ignore failure on chmod in case mode is already set, or is root owned
