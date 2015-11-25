#
# Cookbook Name:: build-essential
# Recipe:: default
#
# Copyright 2008-2009, Chef Software, Inc.
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

begin
  include_recipe "build-essential::_#{node['platform_family']}"
rescue Chef::Exceptions::RecipeNotFound
  Chef::Log.warn <<-EOH
A build-essential recipe does not exist for '#{node['platform_family']}'. This
means the build-essential cookbook does not have support for the
#{node['platform_family']} family. If you are not compiling gems with native
extensions or building packages from source, this will likely not affect you.
EOH
end
