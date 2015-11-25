#
# Cookbook Name:: build-essential
# Library:: timing
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

#
# This module is used to clean up the recipe DSL and "potentially" execute
# resources at compile time (depending on the value of an attribute).
#
# This library is only for use within the build-essential cookbook. Resources
# inside the potentially_at_compile_time block will not fire notifications in
# some situations. This is fixable, but since none of the resources in this
# cookbook actually use notifications, it is not worth the added technical debt.
#
# TL;DR Don't use this DSL method outside of this cookbook.
#
module BuildEssential
  module Timing
    #
    # Potentially evaluate the given block at compile time, depending on the
    # value of the +node['build-essential']['compile_time']+ attribute.
    #
    # @example
    #   potentially_at_compile_time do
    #     package 'apache2'
    #   end
    #
    # @param [Proc] block
    #   the thing to eval
    #
    def potentially_at_compile_time(&block)
      if compile_time?
        CompileTime.new(self).evaluate(&block)
      else
        instance_eval(&block)
      end
    end

    private

    #
    # Checks if the DSL should be evaluated at compile time.
    #
    # @return [true, false]
    #
    def compile_time?
      check_for_old_attributes!
      !!node['build-essential']['compile_time']
    end

    #
    # Checks for the presence of the "old" attributes.
    #
    # @todo Remove in 2.0.0
    #
    # @return [void]
    #
    def check_for_old_attributes!
      unless node['build_essential'].nil?
        Chef::Log.warn <<-EOH
node['build_essential'] has been changed to node['build-essential'] to match the
cookbook name and community standards. I have gracefully converted the attribute
for you, but this warning and conversion will be removed in the next major
release of the build-essential cookbook.
EOH
        node.default['build-essential'] = node['build_essential']
      end

      unless node['build-essential']['compiletime'].nil?
        Chef::Log.warn <<-EOH
node['build-essential']['compiletime'] has been deprecated. Please use
node['build-essential']['compile_time'] instead. I have gracefully converted the
attribute for you, but this warning and conversion will be removed in the next
major release of the build-essential cookbook.
EOH
        node.default['build-essential']['compile_time'] = node['build-essential']['compiletime']
      end
    end

    #
    # A class graciously borrowed from Chef Sugar for evaluating a resource at
    # compile time in a block.
    #
    class CompileTime
      def initialize(recipe)
        @recipe = recipe
      end

      def evaluate(&block)
        instance_eval(&block)
      end

      def method_missing(m, *args, &block)
        resource = @recipe.send(m, *args, &block)
        if resource.is_a?(Chef::Resource)
          actions = Array(resource.action)
          resource.action(:nothing)

          actions.each do |action|
            resource.run_action(action)
          end
        end
        resource
      end
    end
  end
end

# Include the timing module into the main recipe DSL
Chef::Recipe.send(:include, BuildEssential::Timing)
