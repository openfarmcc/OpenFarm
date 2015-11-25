#
# Author:: Kartik Cating-Subramanian (<ksubramanian@chef.io>)
# Copyright:: Copyright (c) 2015 Chef, Inc.
# License:: Apache License, Version 2.0
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


module ChefHandler
  module Helpers

    # Registers a handler in Chef::Config.
    #
    # @param handler_type [Symbol] such as :report or :exception.
    # @param handler [Chef::Handler] handler to register.
    def register_handler(handler_type, handler)
      Chef::Log.info("Enabling #{handler.class.name} as a #{handler_type} handler.")
      Chef::Config.send("#{handler_type.to_s}_handlers") << handler
    end

    # Removes all handlers that match the given class name in Chef::Config.
    #
    # @param handler_type [Symbol] such as :report or :exception.
    # @param class_full_name [String] such as 'Chef::Handler::ErrorReport'.
    def unregister_handler(handler_type, class_full_name)
      Chef::Log.info("Disabling #{class_full_name} as a #{handler_type} handler.")
      Chef::Config.send("#{handler_type.to_s}_handlers").delete_if { |v| v.class.name == class_full_name }
    end

    # Walks down the namespace heirarchy to return the class object for the given class name.
    # If the class is not available, NameError is thrown.
    #
    # @param class_full_name [String] full class name such as 'Chef::Handler::Foo' or 'MyHandler'.
    # @return [Array] parent class and child class.
    def get_class(class_full_name)
      ancestors = class_full_name.split('::')
      class_name = ancestors.pop

      # We need to search the ancestors only for the first/uppermost namespace of the class, so we
      # need to enable the #const_get inherit paramenter only when we are searching in Kernel scope
      # (see COOK-4117).
      parent = ancestors.inject(Kernel) { |scope, const_name| scope.const_get(const_name, scope === Kernel) }
      child = parent.const_get(class_name, parent === Kernel)
      return parent, child
    end
  end
end
