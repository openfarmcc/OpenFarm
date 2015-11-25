#
# Author:: Richard Lavey (richard.lavey@calastone.com)
# Cookbook Name:: windows
# Provider:: certificate_binding
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
include Chef::Mixin::PowershellOut
include Windows::Helper

# Support whyrun
def whyrun_supported?
  true
end

action :create do
  hash = @new_resource.name_kind == :subject ? getHashFromSubject : @new_resource.cert_name

  if @current_resource.exists
    needsChange = (hash.casecmp(@current_hash) != 0)

    if needsChange
      converge_by("Changing #{@current_resource.address}:#{@current_resource.port}") do
        deleteBinding
        setBinding hash
      end
    else
      Chef::Log.debug("#{@current_resource.address}:#{@current_resource.port} already bound to #{hash} - nothing to do")
    end
  else
    converge_by("Binding #{@current_resource.address}:#{@current_resource.port}") do
      setBinding hash
    end
  end
end

action :delete do
  if @current_resource.exists
    converge_by("Deleting #{@current_resource.address}:#{@current_resource.port}") do
      deleteBinding
    end
  else
    Chef::Log.debug("#{@current_resource.address}:#{@current_resource.port} not bound - nothing to do")
  end
end

def load_current_resource
  @current_resource = Chef::Resource::WindowsCertificateBinding.new(@new_resource.name)
  @current_resource.cert_name(@new_resource.cert_name)
  @current_resource.name_kind(@new_resource.name_kind)
  @current_resource.address(@new_resource.address)
  @current_resource.port(@new_resource.port)
  @current_resource.store_name(@new_resource.store_name)

  @command = locate_sysnative_cmd('netsh.exe')
  getCurrentHash
end

private

def getCurrentHash
  cmd = shell_out("#{@command} http show sslcert ipport=#{@current_resource.address}:#{@current_resource.port}")
  Chef::Log.debug "netsh reports: #{cmd.stdout}"

  if cmd.exitstatus == 0
    m = cmd.stdout.scan(/Certificate Hash\s+:\s?([A-Fa-f0-9]{40})/)
    if m.length == 0
      fail "Failed to extract hash from command output #{cmd.stdout}"
    else
      @current_hash = m[0][0]
      @current_resource.exists = true
    end
  else
    @current_resource.exists = false
  end
end

def setBinding(hash)
  cmd = "#{@command} http add sslcert"
  cmd << " ipport=#{@current_resource.address}:#{@current_resource.port}"
  cmd << " certhash=#{hash}"
  cmd << " appid=#{@current_resource.app_id}"
  cmd << " certstorename=#{@current_resource.store_name}"
  checkHash hash

  shell_out!(cmd)
end

def deleteBinding
  shell_out!("#{@command} http delete sslcert ipport=#{@current_resource.address}:#{@current_resource.port}")
end

def checkHash(hash)
  p = powershell_out!("Test-Path \"cert:\\LocalMachine\\#{@current_resource.store_name}\\#{hash}\"")

  unless p.stderr.empty? && p.stdout =~ /True/i
    fail "A Cert with hash of #{hash} doesn't exist in keystore LocalMachine\\#{@current_resource.store_name}"
  end
  nil
end

def getHashFromSubject
  # escape wildcard subject name (*.acme.com)
  subject = @current_resource.cert_name.sub(/\*/, '`*')
  ps_script = "& { gci cert:\\localmachine\\#{@current_resource.store_name} | where subject -like '*#{subject}*' | select -first 1 -expandproperty Thumbprint }"

  Chef::Log.debug "Running PS script #{ps_script}"
  p = powershell_out!(ps_script)

  if !p.stderr.nil? && p.stderr.length > 0
    fail "#{ps_script} failed with #{p.stderr}"
  elsif p.stdout.nil? || p.stdout.length == 0
    fail "Couldn't find thumbprint for subject #{@current_resource.cert_name}"
  end

  p.stdout.strip
end
