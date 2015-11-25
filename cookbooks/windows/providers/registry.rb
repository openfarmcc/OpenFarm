#
# Author:: Doug MacEachern (<dougm@vmware.com>)
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Author:: Paul Morton (<pmorton@biaprotect.com>)
# Cookbook Name:: windows
# Provider:: registry
#
# Copyright:: 2010, VMware, Inc.
# Copyright:: 2011-2015, Chef Software, Inc.
# Copyright:: 2011, Business Intelligence Associates, Inc
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

include Windows::RegistryHelper

action :create do
  updated = registry_update(:create)
  new_resource.updated_by_last_action(updated)
end

action :modify do
  updated = registry_update(:open)
  new_resource.updated_by_last_action(updated)
end

action :force_modify do
  require 'timeout'
  Timeout.timeout(120) do
    @new_resource.values.each do |value_name, value_data|
      i = 1
      until i > 5
        desired_value_data = value_data
        current_value_data = get_value(@new_resource.key_name.dup, value_name.dup)
        if current_value_data.to_s == desired_value_data.to_s
          Chef::Log.debug("#{@new_resource} value [#{value_name}] desired [#{desired_value_data}] data already set. Check #{i}/5.")
          i += 1
        else
          Chef::Log.debug("#{@new_resource} value [#{value_name}] current [#{current_value_data}] data not equal to desired [#{desired_value_data}] data. Setting value and restarting check loop.")
          begin
            updated = registry_update(:open)
            new_resource.updated_by_last_action(updated)
          rescue Exception
            updated = registry_update(:create)
            new_resource.updated_by_last_action(updated)
          end
          i = 0 # start count loop over
        end
      end
    end
    break
  end
end

action :remove do
  delete_value(@new_resource.key_name, @new_resource.values)
  new_resource.updated_by_last_action(true)
end

private

def registry_update(mode)
  Chef::Log.debug("Registry Mode (#{mode})")
  updated = set_value(mode, @new_resource.key_name, @new_resource.values, @new_resource.type)
end
