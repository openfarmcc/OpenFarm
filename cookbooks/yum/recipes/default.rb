#
# Author:: Sean OMeara (<someara@chef.io>)
# Author:: Joshua Timberman (<joshua@chef.io>)
# Recipe:: yum::default
#
# Copyright 2013-2014, Chef Software, Inc (<legal@chef.io>)
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

yum_globalconfig '/etc/yum.conf' do
  node['yum']['main'].each do |config, value|
    send(config.to_sym, value) unless value.nil?
  end

  action :create
end
