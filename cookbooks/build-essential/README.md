Description
===========
[![Cookbook Version](http://img.shields.io/cookbook/v/build-essential.svg)][cookbook]
[![Build Status](http://img.shields.io/travis/chef-cookbooks/build-essential.svg)][travis]

[cookbook]: https://community.chef.io/cookbooks/build-essential
[travis]: http://travis-ci.org/chef-cookbooks/build-essential

Installs packages required for compiling C software from source. Use this
cookbook if you wish to compile C programs, or install RubyGems with native
extensions.

Requirements
------------
Chef 11+ and Ohai 6.14+ are required. For the latest list of supported
platforms, please see the `metadata.rb`.

**Note for Debian platform family:** On Debian platform-family systems, it is recommended that `apt-get update` be run, to ensure that the package cache is updated. It's not in the scope of this cookbook to do that, as it can [create a duplicate resource](https://tickets.chef.io/browse/CHEF-3694). We recommend using the [apt](https://supermarket.chef.io/cookbooks/apt) cookbook to do this.

**Note for OmniOS**: Currently, OmniOS's Ruby package is built with
GCC 4.6.3, and the path is hardcoded, as the gcc binaries are not
installed in the default $PATH. This means that in order to install
RubyGems into the "system" Ruby, one must install `developer/gcc46`.
[An issue](https://github.com/omniti-labs/omnios-build/issues/19) is
open upstream w/ OmniOS to rebuild the Ruby package with GCC 4.7.2.

Attributes
----------
| Attribute      | Default | Description                       |
|----------------|:-------:|-----------------------------------|
| `compile_time` | `false` | Execute resources at compile time |


Usage
-----
Include the build-essential recipe in your run list:

```sh
knife node run_list add NODE "recipe[build-essential::default]"
```

or add the build-essential recipe as a dependency and include it from inside
another cookbook:

```ruby
include_recipe 'build-essential::default'
```

### Gems with C extensions
For RubyGems that include native C extensions you wish to use with Chef, you
should do the following.

1. Set the `compile_time` attribute to true in your wrapper cookbook or role:

    ```ruby
    # Wrapper attribute
    default['build-essential']['compile_time'] = true
    ```

    ```ruby
    # Role
    default_attributes(
      'build-essential' => {
        'compile_time' => true
      }
    )
    ```

1. Ensure that the C libraries, which include files and other assorted "dev"
type packages, are installed in the compile phase after the build-essential
recipe is executed. For example:

    ```ruby
    include_recipe 'build-essential::default'

    package('mypackage-devel') { action :nothing }.run_action(:install)
    ```

1. Use the `chef_gem` resource in your recipe to install the gem with the native
extension:

    ```ruby
    chef_gem 'gem-with-native-extension'
    ```


License & Authors
-----------------
- Author: Seth Vargo (<sethvargo@gmail.com>)
- Author: Joshua Timberman (<joshua@chef.io>)
- Author: Seth Chisamore (<schisamo@chef.io>)

```text
Copyright 2009-2015, Chef Software, Inc. (<legal@chef.io>)

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

