#
# Cookbook Name:: git
# Recipe:: package
#
# Copyright 2008-2015, Chef Software, Inc.
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

case node['platform']
when 'mac_os_x'
  # FIXME: The resource has three distinct groups of properties used in
  # different providers... should we make multiple resource types instead?
  git_client 'default' do
    osx_dmg_app_name  node['git']['osx_dmg']['app_name']
    osx_dmg_package_id node['git']['osx_dmg']['package_id']
    osx_dmg_volumes_dir node['git']['osx_dmg']['volumes_dir']
    osx_dmg_url node['git']['osx_dmg']['url']
    osx_dmg_checksum node['git']['osx_dmg']['checksum']
    action :install
  end
else
  git_client 'default' do
    action :install
  end
end
