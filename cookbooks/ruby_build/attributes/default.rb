#
# Cookbook Name:: ruby_build
# Attributes:: default
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
#
# Copyright 2011, Fletcher Nichol
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# git repository containing the ruby-build framework
default['ruby_build']['git_url'] = "https://github.com/sstephenson/ruby-build.git"
default['ruby_build']['git_ref'] = "master"

# default base path for a system-wide installed Ruby
default['ruby_build']['default_ruby_base_path'] = "/usr/local/ruby"

# ruby-build upgrade action
default['ruby_build']['upgrade'] = "none"

case platform
when "redhat", "centos", "fedora", "amazon", "scientific"
  node.set['ruby_build']['install_pkgs'] = %w{ tar bash curl }
  node.set['ruby_build']['install_git_pkgs'] = %w{ git }
  node.set['ruby_build']['install_pkgs_cruby'] =
    %w{ gcc-c++ patch readline readline-devel zlib zlib-devel
        libffi-devel openssl-devel
        make bzip2 autoconf automake libtool bison
        libxml2 libxml2-devel libxslt libxslt-devel
        subversion autoconf }
  node.set['ruby_build']['install_pkgs_jruby'] = []

when "debian", "ubuntu"
  node.set['ruby_build']['install_pkgs'] = %w{ tar bash curl }
  node.set['ruby_build']['install_git_pkgs'] = %w{ git-core }
  node.set['ruby_build']['install_pkgs_cruby'] =
    %w{ build-essential bison openssl libreadline6 libreadline6-dev
        zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0
        libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev autoconf
        libc6-dev ssl-cert subversion }
  node.set['ruby_build']['install_pkgs_jruby'] = %w{ make g++ }

when "suse"
  node.set['ruby_build']['install_pkgs'] = %w{ tar bash curl }
  node.set['ruby_build']['install_git_pkgs'] = %w{ git-core }
  node.set['ruby_build']['install_pkgs_cruby'] =
    %w{ gcc-c++ patch zlib zlib-devel libffi-devel
        sqlite3-devel libxml2-devel libxslt-devel subversion autoconf }
  node.set['ruby_build']['install_pkgs_jruby'] = []

when "mac_os_x"
  node.set['ruby_build']['install_pkgs'] = []
  node.set['ruby_build']['install_git_pkgs'] = %w{ git-core }
  node.set['ruby_build']['install_pkgs_cruby'] = []
  node.set['ruby_build']['install_pkgs_jruby'] = []
end
