#
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Cookbook Name:: windows
# Library:: helper
#
# Copyright:: 2011-2015, Chef Software, Inc.
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

require 'chef/mixin/shell_out'

module Powershell
  module Helper
    include Chef::Mixin::ShellOut

    def powershell_installed?
      !powershell_version.nil?
    end

    def interpreter
      # force 64-bit powershell from 32-bit ruby process
      if ::File.exist?("#{ENV['WINDIR']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe")
        "#{ENV['WINDIR']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe"
      elsif ::File.exist?("#{ENV['WINDIR']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe")
        "#{ENV['WINDIR']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe"
      else
        'powershell.exe'
      end
    end

    def powershell_version
      cmd = shell_out("#{interpreter} -InputFormat none -Command \"& echo $PSVersionTable.psversion.major\"")
      if cmd.stdout.empty? # PowerShell 1.0 doesn't have a $PSVersionTable
        1
      else
        Regexp.last_match(1).to_i if cmd.stdout =~ /^(\d+)/
      end
    rescue Errno::ENOENT
      nil
    end
  end
end
