Git Cookbook
============

Installs git_client from package or source.
Optionally sets up a git service under xinetd.

Scope
-----
This cookbook is concerned with the Git SCM utility. It does not
address ecosystem tooling or related projects.

Requirements
------------
- Chef 11 or higher
- Ruby 1.9 or higher (preferably from the Chef full-stack installer)
- Network accessible package repositories or a web server hosting source tarballs.

Platform Support
----------------
The following platforms have been tested with Test Kitchen:

```
|--------------+-------|
| centos-5     | X     |
|--------------+-------|
| centos-6     | X     |
|--------------+-------|
| centos-7     | X     |
|--------------+-------|
| fedora-21    | X     |
|--------------+-------|
| debian-7.0   | X     |
|--------------+-------|
| ubuntu-12.04 | X     |
|--------------+-------|
| ubuntu-14.04 | X     |
|--------------+-------|
| ubuntu-15.04 | X     |
|--------------+-------|
```

Cookbook Dependencies
---------------------
- depends 'build-essential' - For compiling from source
- depends 'dmg' - For OSX Support
- depends 'windows' - For Windows support
- depends 'yum-epel' - For older RHEL platform_family support

Usage
-----
- Add `git::default`, `git::source`, of `git::windows` to your run_list
OR
- Add ```depends 'git', '~> 4.3'``` to your cookbook's metadata.rb
- include_recipe one of the recipes from your cookbook
OR
- Use the git_client resource directly, the same way you'd use core
  Chef resources (file, template, directory, package, etc).

Resources Overview
------------------
- `git_client`: Manages a Git client installation on a machine. Acts
  as a singleton when using the (default) package provider. Source
  provider available as well.

- `git_service`: Sets up a Git service via xinetd. WARNING: This is
  insecure and will probably be removed in the future

### git_client

The `git_client` resource manages the installation of a Git client on
a machine.

#### Example
```
git_client 'default' do
  action :install
end
```

#### Properties
Currently, there are distinct sets of resource properties, used by the
providers for source, package, osx, and windows. 

# used by linux package providers
- `package_name` - Package name to install on Linux machines. Defaults to a calculated value based on platform.
- `package_version` - Defaults to nil.
- `package_action` - Defaults to `:install`

# used by source providers
- `source_prefix` - Defaults to '/usr/local'
- `source_url` - Defaults to a calculated URL based on source_version
- `source_version` - Defaults to 1.9.5
- `source_use_pcre` - configure option for build. Defaults to false
- `source_checksum` - Defaults to a known value for the 1.9.5 source tarball

# used by OSX package providers
- `osx_dmg_app_name` - Defaults to 'git-1.9.5-intel-universal-snow-leopard'
- `osx_dmg_package_id` - Defaults to 'GitOSX.Installer.git195.git.pkg'
- `osx_dmg_volumes_dir` - Defaults to 'Git 1.9.5 Snow Leopard Intel Universal'
- `osx_dmg_url` - Defaults to Sourceforge
- `osx_dmg_checksum` - Defaults to the value for 1.9.5

# used by the Windows package providers
- `windows_display_name` - Windows display name
- `windows_package_url` - Defaults to the Internet
- `windows_package_checksum` - Defaults to the value for 1.9.5

Recipes
-------
This cookbook ships with ready to use, attribute driven recipes that utilize the
`git_client` and `git_service` resources. As of cookbook 4.x, they utilize the same
attributes layout scheme from the 3.x. Due to some overlap, it is currently
impossible to simultaneously install the Git client as a package and
from source by using the "manipulate a the node attributes and run a
recipe" technique. If you need both, you'll need to utilize the
git_client resource in a recipe.

Attributes
----------
#### Windows

* `node['git']['version']` - git version to install
* `node['git']['url']` - URL to git package
* `node['git']['checksum']` - package SHA256 checksum
* `node['git']['display_name']` - `windows_package` resource Display Name (makes the package install idempotent)

#### Mac OS X

* `node['git']['osx_dmg']['url']` - URL to git package
* `node['git']['osx_dmg']['checksum']` - package SHA256 checksum

#### Linux

* `node['git']['prefix']` - git install directory
* `node['git']['version']` - git version to install
* `node['git']['url']` - URL to git tarball
* `node['git']['checksum']` - tarball SHA256 checksum
* `node['git']['use_pcre']` - if true, builds git with PCRE enabled

License and Author
==================

- Author:: Joshua Timberman (<joshua@chef.io>)
- Author:: Sean OMeara (<sean@chef.io>)
- Copyright:: 2009-2015, Chef Software, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
