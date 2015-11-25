#
# Author:: Richard Lavey (richard.lavey@calastone.com)
# Cookbook Name:: windows
# Provider:: http_acl
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

# See https://msdn.microsoft.com/en-us/library/windows/desktop/cc307236%28v=vs.85%29.aspx for netsh info

include Chef::Mixin::ShellOut
include Windows::Helper

# Support whyrun
def whyrun_supported?
  true
end

action :create do
  fail 'No user property set' if @new_resource.user.nil? || @new_resource.user.empty?

  if @current_resource.exists
    needsChange = (@current_resource.user.casecmp(@new_resource.user) != 0)

    if needsChange
      converge_by("Changing #{@current_resource.url}") do
        deleteAcl
        setAcl
      end
    else
      Chef::Log.debug("#{@current_resource.url} already set - nothing to do")
    end
  else
    converge_by("Setting #{@current_resource.url}") do
      setAcl
    end
  end
end

action :delete do
  if @current_resource.exists
    converge_by("Deleting #{@current_resource.url}") do
      deleteAcl
    end
  else
    Chef::Log.debug("#{@current_resource.url} does not exist - nothing to do")
  end
end

def load_current_resource
  @current_resource = Chef::Resource::WindowsHttpAcl.new(@new_resource.name)
  @current_resource.url(@new_resource.url)

  @command = locate_sysnative_cmd('netsh.exe')
  getCurrentAcl
end

private

def getCurrentAcl
  cmd = shell_out!("#{@command} http show urlacl url=#{@current_resource.url}")
  Chef::Log.debug "netsh reports: #{cmd.stdout}"

  m = cmd.stdout.scan(/User:\s*(\S+)/)
  if m.length == 0
    @current_resource.exists = false
  else
    @current_resource.user(m[0][0])
    @current_resource.exists = true
  end
end

def setAcl
  shell_out!("#{@command} http add urlacl url=#{@new_resource.url} user=\"#{@new_resource.user}\"")
end

def deleteAcl
  shell_out!("#{@command} http delete urlacl url=#{@new_resource.url}")
end
