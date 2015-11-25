#
# Author:: Greg Zapp (<greg.zapp@gmail.com>)
# Cookbook Name:: windows
# Provider:: feature_powershell
#

include Chef::Provider::WindowsFeature::Base
include Chef::Mixin::PowershellOut
include Windows::Helper

def install_feature(_name)
  cmd = powershell_out("Install-WindowsFeature #{@new_resource.feature_name}")
  Chef::Log.info(cmd.stdout)
end

def remove_feature(_name)
  cmd = powershell_out("Uninstall-WindowsFeature #{@new_resource.feature_name}")
  Chef::Log.info(cmd.stdout)
end

def delete_feature(_name)
  cmd = powershell_out("Uninstall-WindowsFeature #{@new_resource.feature_name} -Remove")
  Chef::Log.info(cmd.stdout)
end

def installed?
  @installed ||= begin
    cmd = powershell_out("Get-WindowsFeature #{@new_resource.feature_name} | Select Installed | % { Write-Host $_.Installed }")
    cmd.stderr.empty? && cmd.stdout =~ /True/i
  end
end

def available?
  @available ||= begin
    cmd = powershell_out("Get-WindowsFeature #{@new_resource.feature_name}")
    cmd.stderr.empty? && cmd.stdout !~ /Removed/i
  end
end
