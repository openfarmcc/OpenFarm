#
# Author:: Doug MacEachern (<dougm@vmware.com>)
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Cookbook Name:: windows
# Resource:: registry
#
# Copyright:: 2010, VMware, Inc.
# Copyright:: 2011-2015, Chef Software, Inc.
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

actions :create, :modify, :force_modify, :remove

attribute :key_name, kind_of: String, name_attribute: true
attribute :values, kind_of: Hash
attribute :type, kind_of: Symbol, default: nil, equal_to: [:binary, :string, :multi_string, :expand_string, :dword, :dword_big_endian, :qword]

def initialize(name, run_context = nil)
  super
  @action = :modify
  @key_name = name
  Chef::Log.warn <<-EOF
Please use the registry_key resource in Chef Client 11 and 12.
windows_registry will be removed in the next major version release
of the Windows cookbook.
EOF
end
