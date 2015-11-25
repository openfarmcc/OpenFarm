#
# Author:: Richard Lavey (richard.lavey@calastone.com)
# Cookbook Name:: windows
# Provider:: certificate
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

# See this for info on certutil
# https://technet.microsoft.com/en-gb/library/cc732443.aspx

include Windows::Helper

# Support whyrun
def whyrun_supported?
  true
end

use_inline_resources

action :create do
  hash = '$cert.GetCertHashString()'
  code_script = cert_script(true) <<
                within_store_script { |store| store + '.Add($cert)' } <<
                acl_script(hash)

  guard_script = cert_script(false) <<
                 cert_exists_script(hash)

  powershell_script @new_resource.name do
    guard_interpreter :powershell_script
    convert_boolean_return true
    code code_script
    not_if guard_script
  end
end

# acl_add is a modify-if-exists operation : not idempotent
action :acl_add do
  if ::File.exist?(@new_resource.source)
    hash = '$cert.GetCertHashString()'
    code_script = cert_script(false)
    guard_script = cert_script(false)
  else
    # make sure we have no spaces in the hash string
    hash = "\"#{@new_resource.source.gsub(/\s/, '')}\""
    code_script = ''
    guard_script = ''
  end
  code_script << acl_script(hash)
  guard_script << cert_exists_script(hash)

  powershell_script @new_resource.name do
    guard_interpreter :powershell_script
    convert_boolean_return true
    code code_script
    only_if guard_script
  end
end

action :delete do
  # do we have a hash or a subject?
  # TODO: It's a bit annoying to know the thumbprint of a cert you want to remove when you already
  # have the file.  Support reading the hash directly from the file if provided.
  if @new_resource.source.match(/^[a-fA-F0-9]{40}$/)
    search = "Thumbprint -eq '#{@new_resource.source}'"
  else
    search = "Subject -like '*#{@new_resource.source.sub(/\*/, '`*')}*'" # escape any * in the source
  end
  cert_command = "Get-ChildItem Cert:\\#{@location}\\#{@new_resource.store_name} | where { $_.#{search} }"

  code_script = within_store_script do |store|
    <<-EOH
foreach ($c in #{cert_command})
{
  #{store}.Remove($c)
}
EOH
  end
  guard_script = "@(#{cert_command}).Count -gt 0\n"

  powershell_script @new_resource.name do
    guard_interpreter :powershell_script
    convert_boolean_return true
    code code_script
    only_if guard_script
  end
end

def load_current_resource
  # Currently we don't read out the cert acl here and converge it in a very Chef-y way.
  # We also don't read if the private key is available or populate "exists".  This means
  # that if you converged a cert without persisting the private key once, we won't do it
  # again, even if you have a cert with the keys now.
  # TODO:  Make this more Chef-y and follow a more state-based patten of convergence.
  @current_resource = Chef::Resource::WindowsCertificate.new(@new_resource.name)
  # TODO: Change to allow source to be read from the cookbook.  It makes testing
  # and loading certs from the cookbook much easier.
  @current_resource.source(@new_resource.source)
  @current_resource.pfx_password(@new_resource.pfx_password)
  @current_resource.private_key_acl(@new_resource.private_key_acl)
  @current_resource.store_name(@new_resource.store_name)
  @current_resource.user_store(@new_resource.user_store)
  @location = @current_resource.user_store ? 'CurrentUser' : 'LocalMachine'
end

private

def cert_script(persist)
  cert_script = '$cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2'
  file = win_friendly_path(@new_resource.source)
  cert_script << " \"#{file}\""
  if ::File.extname(file.downcase) == '.pfx'
    cert_script << ", \"#{@new_resource.pfx_password}\""
    if persist && @new_resource.user_store
      cert_script << ', [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::PersistKeySet'
    elsif persist
      cert_script << ', ([System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::PersistKeySet -bor [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::MachineKeyset)'
    end
  end
  cert_script << "\n"
end

def cert_exists_script(hash)
  <<-EOH
$hash = #{hash}
Test-Path "Cert:\\#{@location}\\#{@new_resource.store_name}\\$hash"
EOH
end

def within_store_script
  inner_script = yield '$store'
  <<-EOH
$store = New-Object System.Security.Cryptography.X509Certificates.X509Store "#{@new_resource.store_name}", ([System.Security.Cryptography.X509Certificates.StoreLocation]::#{@location})
$store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
#{inner_script}
$store.Close()
EOH
end

def acl_script(hash)
  return '' if @new_resource.private_key_acl.nil? || @new_resource.private_key_acl.length == 0
  # this PS came from http://blogs.technet.com/b/operationsguy/archive/2010/11/29/provide-access-to-private-keys-commandline-vs-powershell.aspx
  # and from https://msdn.microsoft.com/en-us/library/windows/desktop/bb204778(v=vs.85).aspx
  set_acl_script = <<-EOH
$hash = #{hash}
$storeCert = Get-ChildItem "cert:\\#{@location}\\#{@new_resource.store_name}\\$hash"
if ($storeCert -eq $null) { throw 'no key exists.' }
$keyname = $storeCert.PrivateKey.CspKeyContainerInfo.UniqueKeyContainerName
if ($keyname -eq $null) { throw 'no private key exists.' }
if ($storeCert.PrivateKey.CspKeyContainerInfo.MachineKeyStore)
{
$fullpath = "$Env:ProgramData\\Microsoft\\Crypto\\RSA\\MachineKeys\\$keyname"
}
else
{
$currentUser = New-Object System.Security.Principal.NTAccount($Env:UserDomain, $Env:UserName)
$userSID = $currentUser.Translate([System.Security.Principal.SecurityIdentifier]).Value
$fullpath = "$Env:ProgramData\\Microsoft\\Crypto\\RSA\\$userSID\\$keyname"
}
EOH
  @new_resource.private_key_acl.each do |name|
    set_acl_script << "$uname='#{name}'; icacls $fullpath /grant $uname`:RX\n"
  end
  set_acl_script
end
