vim Cookbook
============

[![Build Status](https://travis-ci.org/chef-cookbooks/vim.svg?branch=master)](https://travis-ci.org/chef-cookbooks/vim)
[![Cookbook Version](https://img.shields.io/cookbook/v/vim.svg)](https://supermarket.chef.io/cookbooks/vim)

Installs or compiles/installs vim.

Requirements
------------
#### Platforms

* Ubuntu/Debian
* RHEL/CentOS/Scientific/Amazon/Oracle
* Fedora

#### Chef
- Chef 12.1+

#### Cookbooks
- none


Attributes
----------
#### Default recipe attributes:

* `node['vim']['extra_packages']` - An array of extra packages related to vim to install (like plugins). Empty array by default.

* `node['vim']['install_method']` - Sets the install method, choose from the various install recipes. This attribute is set to 'package' by default.


#### Source recipe attributes:

* `node['vim']['source']['version']` -  The version of vim to compile, 7.4 by default.
* `node['vim']['source']['checksum']` -  The source file checksum.
* `node['vim']['source']['dependencies']` - These are the non rhl specific devel dependencies for compiling vim.
* `node['vim']['source']['centos_dependencies']` - These are the rhl and centos specific dependencies needed for compiling vim.
* `node['vim']['source']['prefix']` - This is the path the vim bin will be placed, it's `/usr/local`
* `node['vim']['source']['configuration']` - If you prefer to compile vim differently than the default you can override this configuration.

Usage
-----
Put `recipe[vim]` in a run list, or `include_recipe 'vim'` to ensure that vim is installed on your systems.

If you would like to install additional vim plugin packages, include their package names in the `node['vim']['extra_packages']` attribute. Verify that your operating sytem has the package available.

If you would rather compile vim from source, as the case may be for centos nodes, then override the `node['vim']['install_method']` with a value of `'source'`.



License & Authors
-----------------

**Author:** Cookbook Engineering Team (<cookbooks@chef.io>)

**Copyright:** 2008-2015, Chef Software, Inc.

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
