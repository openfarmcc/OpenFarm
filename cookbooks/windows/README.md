Windows Cookbook
================
[![Build Status](https://travis-ci.org/chef-cookbooks/windows.svg?branch=master)](http://travis-ci.org/chef-cookbooks/windows)
[![Cookbook Version](https://img.shields.io/cookbook/v/windows.svg)](https://supermarket.chef.io/cookbooks/windows)

Provides a set of Windows-specific primitives (Chef resources) meant to aid in the creation of cookbooks/recipes targeting the Windows platform.


Requirements
------------
#### Platforms
* Windows Vista
* Windows 7
* Windows Server 2008 (R1, R2)
* Windows 8, 8.1
* Windows Server 2012 (R1, R2)

#### Chef
- Chef 11+

#### Cookbooks
* chef_handler (`windows::reboot_handler` leverages the chef_handler LWRP)


Attributes
----------
* `node['windows']['allow_pending_reboots']` - used to configure the `WindowsRebootHandler` (via the `windows::reboot_handler` recipe) to act on pending reboots. default is true (ie act on pending reboots).  The value of this attribute only has an effect if the `windows::reboot_handler` is in a node's run list.
* `node['windows']['allow_reboot_on_failure']` - used to register the `WindowsRebootHandler` (via the `windows::reboot_handler` recipe) as an exception handler too to act on reboots not only at the end of successful Chef runs, but even at the end of failed runs. default is false (ie reboot only after successful runs).  The value of this attribute only has an effect if the `windows::reboot_handler` is in a node's run list.


Resource/Provider
-----------------
### windows_auto_run
#### Actions
- `:create` - Create an item to be run at login
- `:remove` - Remove an item that was previously setup to run at login

#### Attribute Parameters
- `name` - Name attribute. The name of the value to be stored in the registry
- `program` - The program to be run at login
- `args` - The arguments for the program

#### Examples
Run BGInfo at login

```ruby
windows_auto_run 'BGINFO' do
  program 'C:/Sysinternals/bginfo.exe'
  args    '\'C:/Sysinternals/Config.bgi\' /NOLICPROMPT /TIMER:0'
  not_if  { Registry.value_exists?(AUTO_RUN_KEY, 'BGINFO') }
  action  :create
end
```

### windows_batch
This resource is now deprecated and will be removed in a future version of this cookbook.  Chef >= 11.6.0 includes a built-in [batch](http://docs.chef.io/resource_batch.html) resource.

Execute a batch script using the cmd.exe interpreter (much like the script resources for bash, csh, powershell, perl, python and ruby). A temporary file is created and executed like other script resources, rather than run inline. By their nature, Script resources are not idempotent, as they are completely up to the user's imagination. Use the `not_if` or `only_if` meta parameters to guard the resource for idempotence.

#### Actions
- `:run` - run the batch file

#### Attribute Parameters
- `command` - name attribute. Name of the command to execute.
- `code` - quoted string of code to execute.
- `creates` - a file this command creates - if the file exists, the command will not be run.
- `cwd` - current working directory to run the command from.
- `flags` - command line flags to pass to the interpreter when invoking.
- `user` - A user name or user ID that we should change to before running this command.
- `group` - A group name or group ID that we should change to before running this command.

#### Examples
```ruby
windows_batch 'unzip_and_move_ruby' do
  code <<-EOH
  7z.exe x #{Chef::Config[:file_cache_path]}/ruby-1.8.7-p352-i386-mingw32.7z  -oC:\\source -r -y
  xcopy C:\\source\\ruby-1.8.7-p352-i386-mingw32 C:\\ruby /e /y
  EOH
end
```

```ruby
windows_batch 'echo some env vars' do
  code <<-EOH
  echo %TEMP%
  echo %SYSTEMDRIVE%
  echo %PATH%
  echo %WINDIR%
  EOH
end
```

### windows_certificate

Installs a certificate into the Windows certificate store from a file, and grants read-only access to the private key for designated accounts.
Due to current limitations in winrm, installing certificated remotely may not work if the operation requires a user profile.  Operations on the local machine store should still work.

#### Actions
- `:create` - creates or updates a certificate.
- `:delete` - deletes a certificate.
- `:acl_add` - adds read-only entries to a certificate's private key ACL.

#### Attribute Parameters
- `source` - name attribute. The source file (for create and acl_add), thumprint (for delete and acl_add) or subject (for delete).
- `pfx_password` - the password to access the source if it is a pfx file.
- `private_key_acl` - array of 'domain\account' entries to be granted read-only access to the certificate's private key. This is not idempotent.
- `store_name` - the certificate store to maniplate. One of MY (default : personal store), CA (trusted intermediate store) or ROOT (trusted root store).
- `user_store` - if false (default) then use the local machine store; if true then use the current user's store.

#### Examples
```ruby
# Add PFX cert to local machine personal store and grant accounts read-only access to private key
windows_certificate "c:/test/mycert.pfx" do
	pfx_password	"password"
	private_key_acl	["acme\fred", "pc\jane"]
end
```

```ruby
# Add cert to trusted intermediate store
windows_certificate "c:/test/mycert.cer" do
	store_name	"CA"
end
```

```ruby
# Remove all certicates matching the subject
windows_certificate "me.acme.com" do
	action :delete
end
```

### windows_certificate_binding

Binds a certificate to an HTTP port in order to enable TLS communication.

#### Actions
- `:create` - creates or updates a binding.
- `:delete` - deletes a binding.

#### Attribute Parameters
- `cert_name` - name attribute. The thumprint(hash) or subject that identifies the certicate to be bound.
- `name_kind` - indicates the type of cert_name. One of :subject (default) or :hash.
- `address` - the address to bind against. Default is 0.0.0.0 (all IP addresses).
- `port` - the port to bind against. Default is 443.
- `app_id` - the GUID that defines the application that owns the binding. Default is the values used by IIS.
- `store_name` - the store to locate the certificate in. One of MY (default : personal store), CA (trusted intermediate store) or ROOT (trusted root store).

#### Examples
```ruby
# Bind the first certificate matching the subject to the default TLS port
windows_certificate_binding "me.acme.com" do
end
```

```ruby
# Bind a cert from the CA store with the given hash to port 4334
windows_certificate_binding "me.acme.com" do
	cert_name	"d234567890a23f567c901e345bc8901d34567890"
	name_kind	:hash
	store_name	"CA"
	port		4334
end
```

### windows_feature
Windows Roles and Features can be thought of as built-in operating system packages that ship with the OS.  A server role is a set of software programs that, when they are installed and properly configured, lets a computer perform a specific function for multiple users or other computers within a network.  A Role can have multiple Role Services that provide functionality to the Role.  Role services are software programs that provide the functionality of a role. Features are software programs that, although they are not directly parts of roles, can support or augment the functionality of one or more roles, or improve the functionality of the server, regardless of which roles are installed.  Collectively we refer to all of these attributes as 'features'.

This resource allows you to manage these 'features' in an unattended, idempotent way.

There are two providers for the `windows_features` which map into Microsoft's two major tools for managing roles/features: [Deployment Image Servicing and Management (DISM)](http://msdn.microsoft.com/en-us/library/dd371719%28v=vs.85%29.aspx) and [Servermanagercmd](http://technet.microsoft.com/en-us/library/ee344834%28WS.10%29.aspx) (The CLI for Server Manager).  As Servermanagercmd is deprecated, Chef will set the default provider to `Chef::Provider::WindowsFeature::DISM` if DISM is present on the system being configured.  The default provider will fall back to `Chef::Provider::WindowsFeature::ServerManagerCmd`.

For more information on Roles, Role Services and Features see the [Microsoft TechNet article on the topic](http://technet.microsoft.com/en-us/library/cc754923.aspx).  For a complete list of all features that are available on a node type either of the following commands at a command prompt:

```text
dism /online /Get-Features
servermanagercmd -query
```

#### Actions
- `:install` - install a Windows role/feature
- `:remove` - remove a Windows role/feature

#### Attribute Parameters
- `feature_name` - name of the feature/role to install.  The same feature may have different names depending on the provider used (ie DHCPServer vs DHCP; DNS-Server-Full-Role vs DNS).
- `all` - Boolean. Optional. Default: false. DISM provider only. Forces all dependencies to be installed.
- `source` - String. Optional. DISM provider only. Uses local repository for feature install.

#### Providers
- **Chef::Provider::WindowsFeature::DISM**: Uses Deployment Image Servicing and Management (DISM) to manage roles/features.
- **Chef::Provider::WindowsFeature::ServerManagerCmd**: Uses Server Manager to manage roles/features.
- **Chef::Provider::WindowsFeaturePowershell**: Uses Powershell to manage roles/features. (see [COOK-3714](https://tickets.chef.io/browse/COOK-3714)

#### Examples
Enable the node as a DHCP Server

```ruby
windows_feature 'DHCPServer' do
  action :install
end
```

Enable TFTP

```ruby
windows_feature 'TFTP' do
  action :install
end
```

Enable .Net 3.5.1 on Server 2012 using repository files on DVD and
install all dependencies

```ruby
windows_feature "NetFx3" do
  action :install
  all true
  source "d:\sources\sxs"
end
```

Disable Telnet client/server

```ruby
%w[TelnetServer TelnetClient].each do |feature|
  windows_feature feature do
    action :remove
  end
end
```

Add SMTP Feature with powershell provider

```ruby
windows_feature "smtp-server" do
  action :install
  all true
  provider :windows_feature_powershell
end
```

### windows_font
Installs a font.

Font files should be included in the cookbooks

#### Actions
- `:install` - install a font to the system fonts directory.

#### Attribute Parameters
- `file` - The name of the font file name to install. It should exist in the files/default directory of the cookbook you're calling windows_font from. Defaults to the resource name.

#### Examples

```ruby
windows_font 'Code New Roman.otf'
```

### windows_http_acl
Sets the Access Control List for an http URL to grant non-admin accounts permission to open HTTP endpoints.

#### Actions
- `:create` - creates or updates the ACL for a URL.
- `:delete` - deletes the ACL from a URL.

#### Attribute Parameters
- `url` - the name of the url to be created/deleted.
- `user` - the name (domain\user) of the user or group to be granted permission to the URL. Mandatory for create. Only one user or group can be granted permission so this replaces any previously defined entry.

#### Examples

```ruby
windows_http_acl 'http://+:50051/' do
	user 'pc\\fred'
end
```

```ruby
windows_http_acl 'http://+:50051/' do
	action :delete
end
```

### windows_package
Manage Windows application packages in an unattended, idempotent way.

The following application installers are currently supported:

* MSI packages
* InstallShield
* Wise InstallMaster
* Inno Setup
* Nullsoft Scriptable Install System

If the proper installer type is not passed into the resource's installer_type attribute, the provider will do it's best to identify the type by introspecting the installation package.  If the installation type cannot be properly identified the `:custom` value can be passed into the installer_type attribute along with the proper flags for silent/quiet installation (using the `options` attribute..see example below).

__PLEASE NOTE__ - For proper idempotence the resource's `package_name` should be the same as the 'DisplayName' registry value in the uninstallation data that is created during package installation.  The easiest way to definitively find the proper 'DisplayName' value is to install the package on a machine and search for the uninstall information under the following registry keys:

* `HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall`
* `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall`
* `HKEY_LOCAL_MACHINE\Software\Wow6464Node\Microsoft\Windows\CurrentVersion\Uninstall`

For maximum flexibility the `source` attribute supports both remote and local installation packages.

#### Actions
- `:install` - install a package
- `:remove` - remove a package. The remove action is completely hit or miss as many application uninstallers do not support a full silent/quiet mode.

#### Attribute Parameters
- `package_name` - name attribute. The 'DisplayName' of the application installation package.
- `source` - The source of the windows installer.  This can either be a URI or a local path.
- `installer_type` - They type of windows installation package. Valid values include :msi, :inno, :nsis, :wise, :installshield, :custom.  If this value is not provided, the provider will do it's best to identify the installer type through introspection of the file.
- `checksum` - useful if source is remote, the SHA-256 checksum of the file--if the local file matches the checksum, Chef will not download it
- `options` - Additional options to pass the underlying installation command
- `timeout` - set a timeout for the package download (default 600 seconds)
- `version` - The version number of this package, as indicated by the 'DisplayVersion' value in one of the 'Uninstall' registry keys.  If the given version number does equal the 'DisplayVersion' in the registry, the package will be installed.
- `success_codes` - set an array of possible successful installation
  return codes. Previously this was hardcoded, but certain MSIs may
  have a different return code, e.g. 3010 for reboot required. Must be
  an array, and defaults to `[0, 42, 127]`.

#### Examples

Install PuTTY (InnoSetup installer)
```ruby
windows_package 'PuTTY version 0.60' do
  source 'http://the.earth.li/~sgtatham/putty/latest/x86/putty-0.60-installer.exe'
  installer_type :inno
  action :install
end
```

Install 7-Zip (MSI installer)
```ruby
windows_package '7-Zip 9.20 (x64 edition)' do
  source 'http://downloads.sourceforge.net/sevenzip/7z920-x64.msi'
  action :install
end
```

Install Notepad++ (Y U No Emacs?) using a local installer
```ruby
windows_package 'Notepad++' do
  source 'c:/installation_files/npp.5.9.2.Installer.exe'
  action :install
end
```

Install VLC for that Xvid (NSIS installer)
```ruby
windows_package 'VLC media player 1.1.10' do
  source 'http://superb-sea2.dl.sourceforge.net/project/vlc/1.1.10/win32/vlc-1.1.10-win32.exe'
  action :install
end
```

Install Firefox as custom installer and manually set the silent install flags
```ruby
windows_package 'Mozilla Firefox 5.0 (x86 en-US)' do
  source 'http://archive.mozilla.org/pub/mozilla.org/mozilla.org/firefox/releases/5.0/win32/en-US/Firefox%20Setup%205.0.exe'
  options '-ms'
  installer_type :custom
  action :install
end
```

Google Chrome FTW (MSI installer)
```ruby
windows_package 'Google Chrome' do
  source 'https://dl-ssl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B806F36C0-CB54-4A84-A3F3-0CF8A86575E0%7D%26lang%3Den%26browser%3D3%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dfalse/edgedl/chrome/install/GoogleChromeStandaloneEnterprise.msi'
  action :install
end
```

Remove Google Chrome
```ruby
windows_package 'Google Chrome' do
  action :remove
end
```

Remove 7-Zip
```ruby
windows_package '7-Zip 9.20 (x64 edition)' do
  action :remove
end
```

### windows_printer_port

Create and delete TCP/IPv4 printer ports.

#### Actions
- `:create` - Create a TCIP/IPv4 printer port. This is the default action.
- `:delete` - Delete a TCIP/IPv4 printer port

#### Attribute Parameters
- `ipv4_address` - Name attribute. Required. IPv4 address, e.g. '10.0.24.34'
- `port_name` - Port name. Optional. Defaults to 'IP_' + `ipv4_address`
- `port_number` - Port number. Optional. Defaults to 9100.
- `port_description` - Port description. Optional.
- `snmp_enabled` - Boolean. Optional. Defaults to false.
- `port_protocol` - Port protocol, 1 (RAW), or 2 (LPR). Optional. Defaults to 1.

#### Examples

Create a TCP/IP printer port named 'IP_10.4.64.37' with all defaults
```ruby
windows_printer_port '10.4.64.37' do
  action :create
end
```

Delete a printer port
```ruby
windows_printer_port '10.4.64.37' do
  action :delete
end
```

Delete a port with a custom port_name
```ruby
windows_printer_port '10.4.64.38' do
  port_name 'My awesome port'
  action :delete
end
```

Create a port with more options
```ruby
windows_printer_port '10.4.64.39' do
  port_name 'My awesome port'
  snmp_enabled true
  port_protocol 2
end
```

### windows_printer

Create Windows printer. Note that this doesn't currently install a printer
driver. You must already have the driver installed on the system.

The Windows Printer LWRP will automatically create a TCP/IP printer port for you using the `ipv4_address` property. If you want more granular control over the printer port, just create it using the `windows_printer_port` LWRP before creating the printer.

#### Actions
- `:create` - Create a new printer
- `:delete` - Delete a new printer

#### Attribute Parameters
- `device_id` - Name attribute. Required. Printer queue name, e.g. 'HP LJ 5200 in fifth floor copy room'
- `comment` - Optional string describing the printer queue.
- `default` - Boolean. Optional. Defaults to false. Note that Windows sets the first printer defined to the default printer regardless of this setting.
- `driver_name` - String. Required. Exact name of printer driver. Note that the printer driver must already be installed on the node.
- `location` - Printer location, e.g. 'Fifth floor copy room', or 'US/NYC/Floor42/Room4207'
- `shared` - Boolean. Defaults to false.
- `share_name` - Printer share name.
- `ipv4_address` - Printer IPv4 address, e.g. '10.4.64.23'. You don't have to be able to ping the IP addresss to set it. Required.

An error of "Set-WmiInstance : Generic failure" is most likely due to the printer driver name not matching or not being installed.

#### Examples

Create a printer
```ruby
windows_printer 'HP LaserJet 5th Floor' do
  driver_name 'HP LaserJet 4100 Series PCL6'
  ipv4_address '10.4.64.38'
end
```

Delete a printer. Note: this doesn't delete the associated printer port. See `windows_printer_port` above for how to delete the port.
```ruby
windows_printer 'HP LaserJet 5th Floor' do
  action :delete
end
```

### windows_reboot
This resource is now deprecated and will be removed in a future version of this cookbook.  Chef >= 12.0.0 includes a built-in [reboot](http://docs.chef.io/resource_reboot.html) resource.

Sets required data in the node's run_state to notify `WindowsRebootHandler` a reboot is requested.  If Chef run completes successfully a reboot will occur if the `WindowsRebootHandler` is properly registered as a report handler.  As an action of `:request` will cause a node to reboot every Chef run, this resource is usually notified by other resources...ie restart node after a package is installed (see example below).

#### Actions
- `:request` - requests a reboot at completion of successful Cher run.  requires `WindowsRebootHandler` to be registered as a report handler.
- `:cancel` - remove reboot request from node.run_state.  this will cancel *ALL* previously requested reboots as this is a binary state.

#### Attribute Parameters
- `timeout` - Name attribute. timeout delay in seconds to wait before proceeding with the requested reboot. default is 60 seconds
- `reason` - comment on the reason for the reboot. default is 'Chef Software Chef initiated reboot'

#### Examples
If the package installs, schedule a reboot at end of chef run
```ruby
windows_reboot 60 do
  reason 'cause chef said so'
  action :nothing
end

windows_package 'some_package' do
  action :install
  notifies :request, 'windows_reboot[60]'
end
```

Cancel the previously requested reboot
```ruby
windows_reboot 60 do
  action :cancel
end
```

### windows_registry
This resource is now deprecated and will be removed in a future version of this cookbook.  Chef >= 11.6.0 includes a built-in [registry_key](http://docs.chef.io/resource_registry_key.html) resource.

Creates and modifies Windows registry keys.

*Change in v1.3.0: The Win32 classes use `::Win32` to avoid namespace conflict with `Chef::Win32` (introduced in Chef 0.10.10).*

#### Actions
- `:create` - create a new registry key with the provided values.
- `:modify` - modify an existing registry key with the provided values.
- `:force_modify` - modify an existing registry key with the provided values.  ensures the value is actually set by checking multiple times. useful for fighting race conditions where two processes are trying to set the same registry key.  This will be updated in the near future to use 'RegNotifyChangeKeyValue' which is exposed by the WinAPI and allows a process to register for notification on a registry key change.
- `:remove` - removes a value from an existing registry key

#### Attribute Parameters
- `key_name` - name attribute. The registry key to create/modify.
- `values` - hash of the values to set under the registry key. The individual hash items will become respective 'Value name' => 'Value data' items in the registry key.
- `type` - Type of key to create, defaults to REG_SZ. Must be a symbol, see the overview below for valid values.

#### Registry key types
- `:binary` - REG_BINARY
- `:string` - REG_SZ
- `:multi_string` - REG_MULTI_SZ
- `:expand_string` - REG_EXPAND_SZ
- `:dword` - REG_DWORD
- `:dword_big_endian` - REG_DWORD_BIG_ENDIAN
- `:qword` - REG_QWORD

#### Examples

Make the local windows proxy match the one set for Chef
```ruby
proxy = URI.parse(Chef::Config[:http_proxy])
windows_registry 'HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings' do
  values 'ProxyEnable' => 1, 'ProxyServer' => "#{proxy.host}:#{proxy.port}", 'ProxyOverride' => '<local>'
end
```

Enable Remote Desktop and poke the firewall hole
```ruby
windows_registry 'HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server' do
  values 'FdenyTSConnections' => 0
end
```

Delete an item from the registry
```ruby
windows_registry 'HKCU\Software\Test' do
  #Key is the name of the value that you want to delete the value is always empty
  values 'ValueToDelete' => ''
  action :remove
end
```

Add a REG_MULTI_SZ value to the registry
```ruby
windows_registry 'HKCU\Software\Test' do
  values 'MultiString' => ['line 1', 'line 2', 'line 3']
  type :multi_string
end
```

### windows_shortcut
Creates and modifies Windows shortcuts.

#### Actions
- `:create` - create or modify a windows shortcut

#### Attribute Parameters
- `name` - name attribute. The shortcut to create/modify.
- `target` - what the shortcut links to
- `arguments` - arguments to pass to the target when the shortcut is executed
- `description` - description of the shortcut
- `cwd` - Working directory to use when the target is executed
- `iconlocation` - Icon to use, in the format of ```"path, index"``` where index is which icon in that file to use (See [WshShortcut.IconLocation](https://msdn.microsoft.com/en-us/library/3s9bx7at.aspx))

#### Examples

Add a shortcut all users desktop:
```ruby
require 'win32ole'
all_users_desktop = WIN32OLE.new("WScript.Shell").SpecialFolders("AllUsersDesktop")

windows_shortcut "#{all_users_desktop}/Notepad.lnk" do
  target "C:\\WINDOWS\\notepad.exe"
  description "Launch Notepad"
  iconlocation "C:\\windows\\notepad.exe, 0"
end
```

#### Library Methods

```ruby
Registry.value_exists?('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run','BGINFO')
Registry.key_exists?('HKLM\SOFTWARE\Microsoft')
BgInfo = Registry.get_value('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run','BGINFO')
```

### windows_path
#### Actions
- `:add` - Add an item to the system path
- `:remove` - Remove an item from the system path

#### Attribute Parameters
- `path` - Name attribute. The name of the value to add to the system path

#### Examples

Add Sysinternals to the system path
```ruby
windows_path 'C:\Sysinternals' do
  action :add
end
```

Remove 7-Zip from the system path
```ruby
windows_path 'C:\7-Zip' do
  action :remove
end
```

### windows_task
Creates, deletes or runs a Windows scheduled task. Requires Windows
Server 2008 due to API usage.

#### Actions
- `:create` - creates a task (or updates existing if user or command has changed)
- `:delete` - deletes a task
- `:run` - runs a task
- `:end` - ends a task
- `:change` - changes the un/pw or command of a task
- `:enable` - enable a task
- `:disable` - disable a task

#### Attribute Parameters
- `task_name` - name attribute, The task name. ("Task Name" or "/Task Name")
- `force` - When used with create, will update the task.
- `command` - The command the task will run.
- `cwd` - The directory the task will be run from.
- `user` - The user to run the task as. (defaults to 'SYSTEM')
- `password` - The user's password. (requires user)
- `run_level` - Run with `:limited` or `:highest` privileges.
- `frequency` - Frequency with which to run the task. (default is :hourly. Other valid values include :minute, :hourly, :daily, :weekly, :monthly, :once, :on_logon, :onstart, :on_idle) \*:once requires start_time
- `frequency_modifier` - Multiple for frequency. (15 minutes, 2 days)
- `start_day` - Specifies the first date on which the task runs. Optional string (MM/DD/YYYY)
- `start_time` - Specifies the start time to run the task. Optional string (HH:mm)
- `interactive_enabled` - (Allow task to run interactively or non-interactively.  Requires user and password.)
- `day` - For monthly or weekly tasks, the day(s) on which the task runs.  (MON - SUN, *, 1 - 31)

#### Examples

Create a `chef-client` task with TaskPath `\` running every 15 minutes
```ruby
windows_task 'chef-client' do
  user 'Administrator'
  password '$ecR3t'
  cwd 'C:\\chef\\bin'
  command 'chef-client -L C:\\tmp\\'
  run_level :highest
  frequency :minute
  frequency_modifier 15
end
```

Update `chef-client` task with new password and log location
```ruby
windows_task 'chef-client' do
  user 'Administrator'
  password 'N3wPassW0Rd'
  cwd 'C:\\chef\\bin'
  command 'chef-client -L C:\\chef\\logs\\'
  action :change
end
```

Delete a taks named `old task`
```ruby
windows_task 'old task' do
  action :delete
end
```

Enable a task named `chef-client`
```ruby
windows_task 'chef-client' do
  action :enable
end
```

Disable a task named `ProgramDataUpdater` with TaskPath `\Microsoft\Windows\Application Experience\`
```ruby
windows_task '\Microsoft\Windows\Application Experience\ProgramDataUpdater' do
  action :disable
end
```

### windows_zipfile
Most version of Windows do not ship with native cli utility for managing compressed files.  This resource provides a pure-ruby implementation for managing zip files. Be sure to use the `not_if` or `only_if` meta parameters to guard the resource for idempotence or action will be taken every Chef run.

#### Actions
- `:unzip` - unzip a compressed file
- `:zip` - zip a directory (recursively)

#### Attribute Parameters
- `path` - name attribute. The path where files will be (un)zipped to.
- `source` - source of the zip file (either a URI or local path) for :unzip, or directory to be zipped for :zip.
- `overwrite` - force an overwrite of the files if they already exist.
- `checksum` - for :unzip, useful if source is remote, if the local file matches the SHA-256 checksum, Chef will not download it.

#### Examples

Unzip a remote zip file locally
```ruby
windows_zipfile 'c:/bin' do
  source 'http://download.sysinternals.com/Files/SysinternalsSuite.zip'
  action :unzip
  not_if {::File.exists?('c:/bin/PsExec.exe')}
end
```

Unzip a local zipfile
```ruby
windows_zipfile 'c:/the_codez' do
  source 'c:/foo/baz/the_codez.zip'
  action :unzip
end
```

Create a local zipfile
```ruby
windows_zipfile 'c:/foo/baz/the_codez.zip' do
  source 'c:/the_codez'
  action :zip
end
```

Libraries
-------------------------
### WindowsHelper

Helper that allows you to use helpful functions in windows

#### installed_packages
Returns a hash of all DisplayNames installed
```ruby
# usage in a recipe
::Chef::Recipe.send(:include, Windows::Helper)
hash_of_installed_packages = installed_packages
```

#### is_package_installed?
- `package_name` - The name of the package you want to query to see if it is installed
- `returns` - true if the package is installed, false if it the package is not installed

Download a file if a package isn't installed
```ruby
# usage in a recipe to not download a file if package is already installed
::Chef::Recipe.send(:include, Windows::Helper)
is_win_sdk_installed = is_package_installed?('Windows Software Development Kit')

remote_file 'C:\windows\temp\windows_sdk.zip' do
  source 'http://url_to_download/windows_sdk.zip'
  action :create_if_missing
  not_if {is_win_sdk_installed}
end
```
Do something if a package is installed
```ruby
# usage in a provider
include Windows::Helper
if is_package_installed?('Windows Software Development Kit')
  # do something if package is installed
end
```

Exception/Report Handlers
-------------------------
### WindowsRebootHandler
Required reboots are a necessary evil of configuring and managing Windows nodes.  This report handler (ie fires at the end of Chef runs) acts on requested (Chef initiated) or pending (as determined by the OS per configuration action we performed) reboots.  The `allow_pending_reboots` initialization argument should be set to false if you do not want the handler to automatically reboot a node if it has been determined a reboot is pending.  Reboots can still be requested explicitly via the `windows_reboot` LWRP.

### Initialization Arguments
- `allow_pending_reboots` - indicator on whether the handler should act on a the Window's 'pending reboot' state. default is true
- `timeout` - timeout delay in seconds to wait before proceeding with the reboot. default is 60 seconds
- `reason` -  comment on the reason for the reboot. default is 'Chef Software Chef initiated reboot'


Windows ChefSpec Matchers
-------------------------
The Windows cookbook includes custom [ChefSpec](https://github.com/sethvargo/chefspec) matchers you can use to test your own cookbooks that consume Windows cookbook LWRPs.

###Example Matcher Usage
```ruby
expect(chef_run).to install_windows_package('Node.js').with(
  source: 'http://nodejs.org/dist/v0.10.26/x64/node-v0.10.26-x64.msi')
```

###Windows Cookbook Matchers
* install_windows_package
* remove_windows_package
* install_windows_feature
* remove_windows_feature
* delete_windows_feature
* create_windows_task
* delete_windows_task
* run_windows_task
* change_windows_task
* add_windows_path
* remove_windows_path
* run_windows_batch
* set_windows_pagefile
* unzip_windows_zipfile_to
* zip_windows_zipfile_to
* create_windows_shortcut
* create_windows_auto_run
* remove_windows_auto_run
* create_windows_printer
* delete_windows_printer
* create_windows_printer_port
* delete_windows_printer_port
* request_windows_reboot
* cancel_windows_reboot
* create_windows_shortcut


Usage
-----

Place an explicit dependency on this cookbook (using depends in the cookbook's metadata.rb) from any cookbook where you would like to use the Windows-specific resources/providers that ship with this cookbook.

```ruby
depends 'windows'
```

### default
Convenience recipe that installs supporting gems for many of the resources/providers that ship with this cookbook.

### reboot_handler
Leverages the `chef_handler` LWRP to register the `WindowsRebootHandler` report handler that ships as part of this cookbook. By default this handler is set to automatically act on pending reboots.  If you would like to change this behavior override `node['windows']['allow_pending_reboots']` and set the value to false.  For example:

```ruby
name 'base'
description 'base role'
override_attributes(
  'windows' => {
    'allow_pending_reboots' => false
  }
)
```

This will still allow a reboot to be explicitly requested via the `windows_reboot` LWRP.

By default, the handler will only be registered as a report handler, meaning that it will only fire at the end of successful Chef runs. If the run fails, pending or requested reboots will be ignored. This can lead to a situation where some package was installed and notified a reboot request via the `windows_reboot` LWRP, and then the run fails for some unrelated reason, and the reboot request gets dropped because the resource that notified the reboot request will already be up-to-date at the next run and will not request a reboot again, and thus the requested reboot will never be performed. To change this behavior and register the handler as an exception handler that fires at the end of failed runs too, override `node['windows']['allow_reboot_on_failure']` and set the value to true.


License & Authors
-----------------
- Author:: Seth Chisamore (<schisamo@chef.io>)
- Author:: Doug MacEachern (<dougm@vmware.com>)
- Author:: Paul Morton (<pmorton@biaprotect.com>)
- Author:: Doug Ireton (<doug.ireton@nordstrom.com>)

```text
Copyright 2011-2015, Chef Software, Inc.
Copyright 2010, VMware, Inc.
Copyright 2011, Business Intelligence Associates, Inc
Copyright 2012, Nordstrom, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
