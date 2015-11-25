# <a name="title"></a> chef-ruby_build

[![Build Status](https://secure.travis-ci.org/fnichol/chef-ruby_build.png?branch=master)](http://travis-ci.org/fnichol/chef-ruby_build)

## <a name="description"></a> Description

Manages the [ruby-build][rb_site] framework and its installed Rubies.
A lightweight resources and providers ([LWRP][lwrp]) is also defined.

## <a name="usage"></a> Usage

Simply include `recipe[ruby_build]` in your run\_list to have ruby-build
installed. You will also have access to the `ruby_build_ruby` resource. See
the [Resources and Providers](#lwrps) section for more details.

## <a name="requirements"></a> Requirements

### <a name="requirements-chef"></a> Chef

Tested on 0.10.8 but newer and older version should work just
fine. File an [issue][issues] if this isn't the case.

### <a name="requirements-platform"></a> Platform

The following platforms have been tested with this cookbook, meaning that
the recipes and LWRPs run on these platforms without error:

* ubuntu (10.04/10.10/11.04/11.10/12.04)
* mac\_os\_x (10.7/10.8)
* debian
* freebsd
* redhat
* centos
* fedora
* amazon
* scientific
* suse

Please [report][issues] any additional platforms so they can be added.

### <a name="requirements-cookbooks"></a> Cookbooks

There are **no** external cookbook dependencies. However, if you are
installing [JRuby][jruby] then a Java runtime will need to be installed.
The Opscode [java cookbook][java_cb] can be used on supported platforms.

## <a name="installation"></a> Installation

Depending on the situation and use case there are several ways to install
this cookbook. All the methods listed below assume a tagged version release
is the target, but omit the tags to get the head of development. A valid
Chef repository structure like the [Opscode repo][chef_repo] is also assumed.

### <a name="installation-platform"></a> From the Opscode Community Platform

To install this cookbook from the Opscode platform, use the *knife* command:

    knife cookbook site install ruby_build

### <a name="installation-berkshelf"></a> Using Berkshelf

[Berkshelf][berkshelf] is a cookbook dependency manager and development
workflow assistant. To install Berkshelf:

    cd chef-repo
    gem install berkshelf
    berks init

To use the Community Site version:

    echo "cookbook 'ruby_build'" >> Berksfile
    berks install

Or to reference the Git version:

    repo="fnichol/chef-ruby_build"
    latest_release=$(curl -s https://api.github.com/repos/$repo/git/refs/tags \
    | ruby -rjson -e '
      j = JSON.parse(STDIN.read);
      puts j.map { |t| t["ref"].split("/").last }.sort.last
    ')
    cat >> Berksfile <<END_OF_BERKSFILE
    cookbook 'ruby_build',
      :git => 'git://github.com/$repo.git', :branch => '$latest_release'
    END_OF_BERKSFILE

### <a name="installation-librarian"></a> Using Librarian-Chef

[Librarian-Chef][librarian] is a bundler for your Chef cookbooks.
To install Librarian-Chef:

    cd chef-repo
    gem install librarian
    librarian-chef init

To use the Opscode platform version:

    echo "cookbook 'ruby_build'" >> Cheffile
    librarian-chef install

Or to reference the Git version:

    repo="fnichol/chef-ruby_build"
    latest_release=$(curl -s https://api.github.com/repos/$repo/git/refs/tags \
    | ruby -rjson -e '
      j = JSON.parse(STDIN.read);
      puts j.map { |t| t["ref"].split("/").last }.sort.last
    ')
    cat >> Cheffile <<END_OF_CHEFFILE
    cookbook 'ruby_build',
      :git => 'git://github.com/$repo.git', :ref => '$latest_release'
    END_OF_CHEFFILE
    librarian-chef install

## <a name="recipes"></a> Recipes

### <a name="recipes-default"></a> default

Installs the ruby-build codebase and initializes Chef to use the Lightweight
Resources and Providers ([LWRPs][lwrp]).

## <a name="attributes"></a> Attributes

### <a name="attributes-git-url"></a> git_url

The Git URL which is used to install ruby-build.

The default is `"git://github.com/sstephenson/ruby-build.git"`.

### <a name="attributes-git-ref"></a> git_ref

A specific Git branch/tag/reference to use when installing ruby-build. For
example, to pin ruby-build to a specific release:

    node['ruby_build']['git_ref'] = "v20111030"

The default is `"master"`.

### <a name="attributes-default-ruby-base-path"></a> default_ruby_base_path

The default base path for a system-wide installed Ruby. For example, the
following resource:

    ruby_build_ruby "1.9.3-p0"

will be installed into
`"#{node['ruby_build']['default_ruby_base_path']}/1.9.3-p0"` unless a
`prefix_path` attribute is explicitly set.

The default is `"/usr/local/ruby"`.

### <a name="attributes-upgrade"></a> upgrade

Determines how to handle installing updates to the ruby-build framework.
There are currently 2 valid values:

* `"none"`, `false`, or `nil`: will not update ruby-build and leave it in its
  current state.
* `"sync"` or `true`: updates ruby-build to the version specified by the
  `git_ref` attribute or the head of the master branch by default.

The default is `"none"`.

## <a name="lwrps"></a> Resources and Providers

### <a name="lwrps-rbr"></a> ruby_build_ruby

#### <a name="lwrps-rbr-actions"></a> Actions

<table>
  <thead>
    <tr>
      <th>Action</th>
      <th>Description</th>
      <th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>install</td>
      <td>
        Build and install a Ruby from a definition file. See the ruby-build
        readme<sup>(1)</sup> for more details.
      </td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>reinstall</td>
      <td>
        Force a recompiliation of the Ruby from source. The :install action
        will skip a build if the target install directory already exists.
      </td>
      <td>&nbsp;</td>
    </tr>
  </tbody>
</table>

1. [ruby-build readme][rb_readme]

#### <a name="lwrps-rbr-attributes"></a> Attributes

<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>definition</td>
      <td>
        <b>Name attribute:</b> the name of a built-in definition<sup>(1)</sup>
        or the path to a ruby-build definition file.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>prefix_path</td>
      <td>The path to which the Ruby will be installed.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>user</td>
      <td>
        A user which will own the installed Ruby. The default value of
        <code>nil</code> denotes a system-wide Ruby (root-owned) is being
        targeted. <b>Note:</b> if specified, the user must already exist.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>group</td>
      <td>
        A group which will own the installed Ruby. The default value of
        <code>nil</code> denotes a system-wide Ruby (root-owned) is being
        targeted. <b>Note:</b> if specified, the group must already exist.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>environment</td>
      <td>
        A Hash of additional environment variables<sup>(2)</sup>, such as
        <code>CONFIGURE_OPTS</code> or <code>RUBY_BUILD_MIRROR_URL</code>.
      </td>
      <td><code>nil</code></td>
    </tr>
  </tbody>
</table>

1. [built-in definition][rb_definitions]
2. [special environment variables][rb_environment]

#### <a name="lwrps-rbr-examples"></a> Examples

##### Install Ruby

    # See: https://github.com/sstephenson/ruby-build/issues/186
    ruby_build_ruby "ree-1.8.7-2012.02" do
      environment({ 'CONFIGURE_OPTS' => '--no-tcmalloc' })
    end

    ruby_build_ruby "1.9.3-p0" do
      prefix_path "/usr/local/ruby/ruby-1.9.3-p0"
      environment({
        'RUBY_BUILD_MIRROR_URL' => 'http://local.example.com'
      })

      action      :install
    end

    ruby_build_ruby "jruby-1.6.5"

**Note:** the install action is default, so the second example is more common.

##### Install A Ruby For A User

    ruby_build_ruby "maglev-1.0.0" do
      prefix_path "/home/deploy/.rubies/maglev-1.0.0"
      user        "deploy"
      group       "deploy"
    end

##### Reinstall Ruby

    ruby_build_ruby "rbx-1.2.4" do
      prefix_path "/opt/rbx-1.2.4"

      action      :reinstall
    end

**Note:** the Ruby will be built whether or not the Ruby exists in the
`prefix_path` directory.

## <a name="development"></a> Development

* Source hosted at [GitHub][repo]
* Report issues/Questions/Feature requests on [GitHub Issues][issues]

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make.

## <a name="license"></a> License and Author

Author:: [Fletcher Nichol][fnichol] (<fnichol@nichol.ca>) [![endorse](http://api.coderwall.com/fnichol/endorsecount.png)](http://coderwall.com/fnichol)

Copyright 2011, Fletcher Nichol

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[berkshelf]:      http://berkshelf.com/
[chef_repo]:      https://github.com/opscode/chef-repo
[cheffile]:       https://github.com/applicationsonline/librarian/blob/master/lib/librarian/chef/templates/Cheffile
[java_cb]:        http://community.opscode.com/cookbooks/java
[jruby]:          http://jruby.org/
[kgc]:            https://github.com/websterclay/knife-github-cookbooks#readme
[librarian]:      https://github.com/applicationsonline/librarian#readme
[lwrp]:           http://wiki.opscode.com/display/chef/Lightweight+Resources+and+Providers+%28LWRP%29
[rb_readme]:      https://github.com/sstephenson/ruby-build#readme
[rb_site]:        https://github.com/sstephenson/ruby-build
[rb_environment]: https://github.com/sstephenson/ruby-build#special-environment-variables
[rb_definitions]: https://github.com/sstephenson/ruby-build/tree/master/share/ruby-build

[fnichol]:      https://github.com/fnichol
[repo]:         https://github.com/fnichol/chef-ruby_build
[issues]:       https://github.com/fnichol/chef-ruby_build/issues
