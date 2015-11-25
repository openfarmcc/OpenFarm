#
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Cookbook Name:: windows
# Resource:: reboot
#
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

actions :request, :cancel

attribute :timeout, kind_of: Integer, name_attribute: true
attribute :reason, kind_of: String, default: 'Chef client run'

def initialize(name, run_context = nil)
  super
  @action = :request
  Chef::Log.warn <<-EOF
The windows_reboot resource is deprecated. Please use the reboot resource in
Chef Client 12. windows_reboot will be removed in the next major version
release of the Windows cookbook.
EOF
end
