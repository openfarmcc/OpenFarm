# Try to include from core chef, if error then monkey patch it in.

begin
  include Chef::Mixin::WindowsArchitectureHelper
rescue
  Chef::Log.debug('Chef::Mixin::WindowsArchitectureHelper not in core version, Monkey patching in.')

  require 'chef/exceptions'
  require 'win32/api' if Chef::Platform.windows?

  class Chef
    module Mixin
      module WindowsArchitectureHelper
        def node_windows_architecture(node)
          node['kernel']['machine'].to_sym
        end

        def wow64_architecture_override_required?(node, desired_architecture)
          i386_windows_process? &&
            node_windows_architecture(node) == :x86_64 &&
            desired_architecture == :x86_64
        end

        def node_supports_windows_architecture?(node, desired_architecture)
          assert_valid_windows_architecture!(desired_architecture)
          (node_windows_architecture(node) == :x86_64 ||
            desired_architecture == :i386) ? true : false
        end

        def valid_windows_architecture?(architecture)
          (architecture == :x86_64) || (architecture == :i386)
        end

        def assert_valid_windows_architecture!(architecture)
          unless valid_windows_architecture?(architecture)
            raise Chef::Exceptions::Win32ArchitectureIncorrect,
              'The specified architecture was not valid. It must be one of :i386 or :x86_64'
          end
        end

        def i386_windows_process?
          Chef::Platform.windows? && 'X86'.casecmp(ENV['PROCESSOR_ARCHITECTURE']) == 0
        end

        def disable_wow64_file_redirection(node)
          original_redirection_state = ['0'].pack('P')

          if (node_windows_architecture(node) == :x86_64) && ::Chef::Platform.windows?
            win32_wow_64_disable_wow_64_fs_redirection =
              ::Win32::API.new('Wow64DisableWow64FsRedirection', 'P', 'L', 'kernel32')

            succeeded = win32_wow_64_disable_wow_64_fs_redirection.call(original_redirection_state)

            if succeeded == 0
              raise Win32APIError 'Failed to disable Wow64 file redirection'
            end

          end

          original_redirection_state
        end

        def restore_wow64_file_redirection(node, original_redirection_state)
          if (node_windows_architecture(node) == :x86_64) && ::Chef::Platform.windows?
            win32_wow_64_revert_wow_64_fs_redirection =
              ::Win32::API.new('Wow64RevertWow64FsRedirection', 'P', 'L', 'kernel32')

            succeeded = win32_wow_64_revert_wow_64_fs_redirection.call(original_redirection_state)

            if succeeded == 0
              raise Win32APIError 'Failed to revert Wow64 file redirection'
            end
          end
        end
      end
    end
  end
end

# Making sure this library is available to Chef::Mixin::PowershellOut
# Required for clients that don't have Chef::Mixin::WindowsArchitectureHelper in
# core chef.
if ::Chef::Platform.windows?
  require_relative 'powershell_out'
  Chef::Mixin::PowershellOut.send(:include, Chef::Mixin::WindowsArchitectureHelper)
end
