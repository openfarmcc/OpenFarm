ohai Cookbook
=============
[![Build Status](https://travis-ci.org/chef-cookbooks/ohai.svg?branch=master)](http://travis-ci.org/chef-cookbooks/ohai)
[![Cookbook Version](https://img.shields.io/cookbook/v/ohai.svg)](https://supermarket.chef.io/cookbooks/ohai)

Creates a configured plugin path for distributing custom Ohai plugins, and reloads them via Ohai within the context of a Chef Client run during the compile phase (if needed).


Requirements
------------
#### Platforms
- Debian/Ubuntu
- RHEL/CentOS/Scientific/Amazon/Oracle
- Windows

#### Chef
- Chef 11+

#### Cookbooks
- none

Attributes
----------
- `node['ohai']['plugin_path']` - location to drop off plugins directory, default is `/etc/chef/ohai_plugins`. This is not FHS-compliant, an FHS location would be something like `/var/lib/ohai/plugins`, or `/var/lib/chef/ohai_plugins` or similar.

    Neither an FHS location or the default value of this attribute are in the default Ohai plugin path. Set the Ohai plugin path with the config setting "`Ohai::Config[:plugin_path]`" in the Chef config file (the `chef-client::config` recipe does this automatically for you!). The attribute is not set to the default plugin path that Ohai ships with because we don't want to risk destroying existing essential plugins for Ohai.

- `node['ohai']['plugins']` - sources of plugins, defaults to the `files/default/plugins` directory of this cookbook. You can add additional cookbooks by adding the name of the cookbook as a key and the path of the files directory as the value. You have to make sure that you don't have any file conflicts between multiple cookbooks. The last one to write wins.

- `node['ohai']['hints_path']` - location to drop off hints directory, default is `/etc/chef/ohai/hints`.

Usage
-----
Put the recipe `ohai` at the start of the node's run list to make sure that custom plugins are loaded early on in the Chef run and data is available for later recipes.

The execution of the custom plugins occurs within the recipe during the compile phase, so you can write new plugins and use the data they return in your Chef recipes.

For information on how to write custom plugins for Ohai, please see the Chef wiki pages.

http://wiki.chef.io/display/chef/Writing+Ohai+Plugins

*PLEASE NOTE* - This recipe reloads the Ohai plugins a 2nd time during the Chef run if:

* The "`Ohai::Config[:plugin_path]`" config setting has *NOT* been properly set in the Chef config file
- The "`Ohai::Config[:plugin_path]`" config setting has been properly set in the Chef config file and there are updated plugins dropped off at "`node['ohai']['plugin_path']`".

LWRP
----

### `ohai_hint`

Create hints file.  You can find usage examples at `test/cookbooks/ohai_test/recipes/*.rb`.

#### Resource Attributes

  -  `hint_name` - The name of hints file and key. Should be string, default is name of resource.
  -  `content` - Values of hints. It will be used as automatic attributes. Should be Hash, default is empty Hash class.

#### ChefSpec Matchers

You can check for the creation or deletion of ohai hints with chefspec using these custom matches:

 - create_ohai_hint
 - delete_ohai_hint

Example
-------
For an example implementation, inspect the ohai_plugin.rb recipe in the nginx community cookbook.


License & Authors
-----------------

**Author:** Cookbook Engineering Team (<cookbooks@chef.io>)

**Copyright:** 2011-2015, Chef Software, Inc.
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
