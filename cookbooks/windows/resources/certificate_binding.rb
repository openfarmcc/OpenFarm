#
# Author:: Richard Lavey (richard.lavey@calastone.com)
# Cookbook Name:: windows
# Resource:: certificate_binding
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

actions :create, :delete
default_action :create

attribute :cert_name, kind_of: String, name_attribute: true, required: true
attribute :name_kind, kind_of: Symbol, equal_to: [:hash, :subject], default: :subject
attribute :address, kind_of: String, default: '0.0.0.0'
attribute :port, kind_of: Integer, default: 443
attribute :app_id, kind_of: String, default: '{4dc3e181-e14b-4a21-b022-59fc669b0914}'
attribute :store_name, kind_of: String, default: 'MY', regex: /^(?:MY|CA|ROOT)$/

attr_accessor :exists
