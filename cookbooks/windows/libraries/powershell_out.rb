
#
# WARNING
#
# THIS CODE HAS BEEN MOVED TO CORE CHEF.  DO NOT SUMBIT PULL REQUESTS AGAINST THIS
# CODE.  IT WILL BE REMOVED IN THE FUTURE.
#

unless defined? Chef::Mixin::PowershellOut
  class Chef
    module Mixin
      module PowershellOut
        include Chef::Mixin::ShellOut

        begin
          include Chef::Mixin::WindowsArchitectureHelper
        rescue
          # nothing to do, as the include will happen when windows_architecture_helper.rb
          # is loaded.  This is for ease of removal of that library when either
          # powershell_out is core chef or powershell cookbook depends upon version
          # of chef that has Chef::Mixin::WindowsArchitectureHelper in core chef
        end

        def powershell_out(*command_args)
          Chef::Log.warn 'The powershell_out library in the windows cookbook is deprecated.'
          Chef::Log.warn 'Please upgrade to Chef 12.4.0 or later where it is built-in to core chef.'
          script = command_args.first
          options = command_args.last.is_a?(Hash) ? command_args.last : nil

          run_command(script, options)
        end

        def powershell_out!(*command_args)
          cmd = powershell_out(*command_args)
          cmd.error!
          cmd
        end

        private

        def run_command(script, options)
          if options && options[:architecture]
            architecture = options[:architecture]
            options.delete(:architecture)
          else
            architecture = node_windows_architecture(node)
          end

          disable_redirection = wow64_architecture_override_required?(node, architecture)

          if disable_redirection
            original_redirection_state = disable_wow64_file_redirection(node)
          end

          command = build_command(script)

          if options
            cmd = shell_out(command, options)
          else
            cmd = shell_out(command)
          end

          if disable_redirection
            restore_wow64_file_redirection(node, original_redirection_state)
          end

          cmd
        end

        def build_command(script)
          flags = [
            # Hides the copyright banner at startup.
            '-NoLogo',
            # Does not present an interactive prompt to the user.
            '-NonInteractive',
            # Does not load the Windows PowerShell profile.
            '-NoProfile',
            # always set the ExecutionPolicy flag
            # see http://technet.microsoft.com/en-us/library/ee176961.aspx
            '-ExecutionPolicy RemoteSigned',
            # Powershell will hang if STDIN is redirected
            # http://connect.microsoft.com/PowerShell/feedback/details/572313/powershell-exe-can-hang-if-stdin-is-redirected
            '-InputFormat None'
          ]

          command = "powershell.exe #{flags.join(' ')} -Command \"#{script}\""
          command
        end
      end
    end
  end
end
