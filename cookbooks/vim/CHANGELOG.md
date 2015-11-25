vim Cookbook CHANGELOG
======================
This file is used to list changes made in each version of the vim cookbook.

v2.0.0 (2015-10-01)
-------------------
- Use multi-package installs introduced in Chef 12.1 to simplify code and speed up installs
- Add Fedora source install support
- Fix CentOS source install support and ensure vim compiles correctly on CentOS 5/6/7
- Fix the tarball checksum to be the actual SHA256 checksum
- Enable lua, perl, tcl support in the source install and add the necessary development packages for that support
- Use the correct ctags package on Debian/Ubuntu systems to prevent errors or warnings
- Improve how the code compilation runs in source installs so that a failed run doesn't prevent subsequent Chef runs or introduce a state where vim is never compiled
- Add basic Serverspec test for source installs to ensure that vim runs
- Fixed the error message is a bad install_method attribute is given to describe the actual problema and vim cookbook

v1.1.4 (2015-09-21)
-------------------
- Converted value_for_platform to value_for_platform_family in order to support all RHEL and Debian derivitives
- Added a Kitchen CI config for integration testing
- Updated Travis to test on the latest ruby versions and to perform Chefspec tests
- Updated Berkfile to 3.X format
- Added updated CONTRIBUTING.MD, TESTING.MD and MAINTAINERS.MD files
- Added Chefspec tests to get coverage to 100%
- Added an expanded .gitignore and a chefignore file to limit the files uploaded to the chef-server
- Added a Rakefile for simplified testing
- Resolved rubocop warnings
- Added Oracle Linux and Amazon Linux to the metadata file
- Updated development dependencies
- Updated Kitchen config to work with the latest in Chef DK

v1.1.2 (2013-12-30)
-------------------
* Fixed Ubuntu package installer bug. Adding specs.

v1.1.0
------
### Improvement
- **[COOK-2465](https://tickets.opscode.com/browse/COOK-2465)** - Add a compile and settings optional recipe.
