#
# Author:: Richard Lavey (richard.lavey@calastone.com)
# Cookbook Name:: windows
# Resource:: certificate
#
# Copyright:: 2015, Calastone Ltd.
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

actions :create, :delete, :acl_add
default_action :create

attribute :source, kind_of: String, name_attribute: true, required: true
attribute :pfx_password, kind_of: String
attribute :private_key_acl, kind_of: Array
attribute :store_name, kind_of: String, default: 'MY', regex: /^(?:MY|CA|ROOT)$/
attribute :user_store, kind_of: [TrueClass, FalseClass], default: false
