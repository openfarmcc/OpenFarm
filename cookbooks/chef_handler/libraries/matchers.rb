#
# Author:: Douglas Thrift (<douglas.thrift@rightscale.com>)
# Cookbook Name:: chef_handler
# Library:: matchers
#
# Copyright 2014, Chef Software, Inc.
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

if defined?(ChefSpec)
  chefspec_version = Gem.loaded_specs["chefspec"].version
  if chefspec_version < Gem::Version.new('4.1.0')
    define_method = ChefSpec::Runner.method(:define_runner_method)
  else
    define_method = ChefSpec.method(:define_matcher)
  end

  define_method.call :chef_handler

  def enable_chef_handler(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:chef_handler, :enable, resource_name)
  end

  def disable_chef_handler(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:chef_handler, :disable, resource_name)
  end
end
