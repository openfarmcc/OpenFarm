#
# Cookbook Name:: build-essential
# Library:: xcode_command_line_tools
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

class Chef
  class Resource::XcodeCommandLineTools < Resource::LWRPBase
    def self.resource_name
      :xcode_command_line_tools
    end

    actions :install
    default_action :install

    def initialize(name, run_context = nil)
      super

      @provider = case node['platform_version'].to_f
                  when 10.7, 10.8
                    Provider::XcodeCommandLineToolsFromDmg
                  when 10.9, 10.10
                    Provider::XcodeCommandLineToolsFromSoftwareUpdate
                  else
                    Chef::Log.warn <<-EOH
OSX #{node['platform_version']} is not an officially supported platform for the
build-essential cookbook. I am going to try and install the command line tools
from Software Update, but there is a high probability that it will fail...

If you have tested and verified OSX #{node['platform_version']} and you are sick
of seeing this warning in your Chef Client runs, please submit a Pull Request to
https://github.com/chef-cookbooks/build-essential and add this version of OSX
to provider list.
EOH
                    Provider::XcodeCommandLineToolsFromSoftwareUpdate
                  end
    end
  end
end

#
# This is a legacy provider for installing OSX from DMGs. It only supports OSX
# versions 10.7 and 10.8 and will (hopefully) be deprecated in the future. It
# downloads a remote .dmg file, mounts it, installs it, and unmounts it
# automatically. In later versions of OSX, the operating system handles this for
# the end user.
#
class Chef
  class Provider::XcodeCommandLineToolsFromDmg < Provider::LWRPBase
    action(:install) do
      if installed?
        Chef::Log.debug("#{new_resource} already installed - skipping")
      else
        converge_by("Install #{new_resource}") do
          download
          attach
          install
          detach
        end
      end
    end

    private

    #
    # Determine if the XCode Command Line Tools are installed
    #
    # @return [true, false]
    #
    def installed?
      cmd = Mixlib::ShellOut.new('pkgutil --pkgs=com.apple.pkg.DeveloperToolsCLI')
      cmd.run_command
      cmd.error!
      true
    rescue Mixlib::ShellOut::ShellCommandFailed
      false
    end

    #
    # The path where the dmg should be cached on disk.
    #
    # @return [String]
    #
    def dmg_cache_path
      ::File.join(Chef::Config[:file_cache_path], 'osx-command-line-tools.dmg')
    end

    #
    # The path where the dmg should be downloaded from. This is intentionally
    # not a configurable object by the end user. If you do not like where we
    # are downloading XCode from - too bad.
    #
    # @return [String]
    #
    def dmg_remote_source
      case node['platform_version'].to_f
      when 10.7
        'http://devimages.apple.com/downloads/xcode/command_line_tools_for_xcode_os_x_lion_april_2013.dmg'
      when 10.8
        'http://devimages.apple.com/downloads/xcode/command_line_tools_for_xcode_os_x_mountain_lion_march_2014.dmg'
      else
        fail "Unknown DMG download URL for OSX #{node['platform_version']}"
      end
    end

    #
    # The path where the volume should be mounted.
    #
    # @return [String]
    #
    def mount_path
      ::File.join(Chef::Config[:file_cache_path], 'osx-command-line-tools')
    end

    #
    # Action: download the remote dmg.
    #
    # @return [void]
    #
    def download
      remote_file = Resource::RemoteFile.new(dmg_cache_path, run_context)
      remote_file.source(dmg_remote_source)
      remote_file.backup(false)
      remote_file.run_action(:create)
    end

    #
    # Action: attach the dmg (basically, double-click on it)
    #
    # @return [void]
    #
    def attach
      execute %(hdiutil attach "#{dmg_cache_path}" -mountpoint "#{mount_path}")
    end

    #
    # Action: install the package inside the dmg
    #
    # @return [void]
    #
    def install
      execute %|installer -package "$(find '#{mount_path}' -name *.mpkg)" -target "/"|
    end

    #
    # Action: detach the dmg (basically, drag it to eject on the dock)
    #
    # @return [void]
    #
    def detach
      execute %(hdiutil detach "#{mount_path}")
    end
  end
end

class Chef
  class Provider::XcodeCommandLineToolsFromSoftwareUpdate < Provider::LWRPBase
    action(:install) do
      if installed?
        Chef::Log.debug("#{new_resource} already installed - skipping")
      else
        converge_by("Install #{new_resource}") do
          # This script was graciously borrowed and modified from Tim Sutton's
          # osx-vm-templates at https://github.com/timsutton/osx-vm-templates/blob/b001475df54a9808d3d56d06e71b8fa3001fff42/scripts/xcode-cli-tools.sh
          execute 'install XCode Command Line tools' do
            command <<-EOH.gsub(/^ {14}/, '')
              # create the placeholder file that's checked by CLI updates' .dist code
              # in Apple's SUS catalog
              touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
              # find the CLI Tools update
              PROD=$(softwareupdate -l | grep "\*.*Command Line" | head -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n')
              # install it
              softwareupdate -i "$PROD" -v
            EOH
            # rubocop:enable Metrics/LineLength
          end
        end
      end
    end

    private

    #
    # Determine if the XCode Command Line Tools are installed
    #
    # @return [true, false]
    #
    def installed?
      cmd = Mixlib::ShellOut.new('pkgutil --pkgs=com.apple.pkg.CLTools_Executables')
      cmd.run_command
      cmd.error!
      true
    rescue Mixlib::ShellOut::ShellCommandFailed
      false
    end
  end
end
