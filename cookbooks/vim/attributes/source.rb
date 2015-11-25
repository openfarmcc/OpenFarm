#
# Cookbook Name:: vim
# Attributes:: source
#
# Copyright 2013-2015, Chef Software, Inc.
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

default['vim']['source']['version']       = '7.4'
default['vim']['source']['checksum']      = 'd0f5a6d2c439f02d97fa21bd9121f4c5abb1f6cd8b5a79d3ca82867495734ade'
default['vim']['source']['prefix']        = '/usr/local'
default['vim']['source']['configuration'] = "--without-x --enable-pythoninterp --enable-rubyinterp --enable-tclinterp --enable-luainterp --enable-perlinterp --enable-cscope  --with-features=huge --prefix=#{default['vim']['source']['prefix']}"

if platform_family? 'rhel', 'fedora'
  if node['platform_version'].to_i >= 6
    default['vim']['source']['dependencies'] = %w( ctags
                                                   gcc
                                                   lua-devel
                                                   make
                                                   ncurses-devel
                                                   perl-devel
                                                   perl-ExtUtils-CBuilder
                                                   perl-ExtUtils-Embed
                                                   perl-ExtUtils-ParseXS
                                                   python-devel
                                                   ruby-devel
                                                   tcl-devel
                                               )
  else # centos 5 and earlier lack lua, luajit, and many of the perl packages found in later releases.  Also installs fail without libselinux-devel
    default['vim']['source']['dependencies'] = %w( ctags
                                                   gcc
                                                   make
                                                   ncurses-devel
                                                   perl
                                                   python-devel
                                                   ruby-devel
                                                   tcl-devel
                                                   libselinux-devel
                                               )
  end
else
  default['vim']['source']['dependencies'] = %w( exuberant-ctags
                                                 gcc
                                                 libncurses5-dev
                                                 libperl-dev
                                                 lua5.1
                                                 make
                                                 python-dev
                                                 ruby-dev
                                                 tcl-dev
                                             )
end
