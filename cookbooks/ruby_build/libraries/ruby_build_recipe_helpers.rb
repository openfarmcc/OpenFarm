#
# Cookbook Name:: ruby_build
# Library:: Chef::RubyBuild::RecipeHelpers
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
#
# Copyright 2011, Fletcher Nichol
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

class Chef
  module RubyBuild
    module RecipeHelpers
      def build_upgrade_strategy(strategy)
        if strategy.nil? || strategy == false
          "none"
        else
          strategy
        end
      end

      def mac_with_no_homebrew
        node['platform'] == 'mac_os_x' &&
          Chef::Platform.find_provider_for_node(node, :package) !=
          Chef::Provider::Package::Homebrew
      end
    end
  end
end
