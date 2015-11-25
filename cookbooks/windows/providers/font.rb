#
# Author:: Sander Botman <sbotman@schubergphilis.com>
# Cookbook Name:: windows
# Provider:: font
#
# Copyright:: 2014, Schuberg Philis BV.
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
include Windows::Helper

def load_current_resource
  require 'win32ole'
  fonts_dir = WIN32OLE.new('WScript.Shell').SpecialFolders('Fonts')
  @current_resource = Chef::Resource::WindowsFont.new(@new_resource.name)
  @current_resource.file(win_friendly_path(::File.join(fonts_dir, @new_resource.file)))
  @current_resource
end

# Check to see if the font is installed
#
# === Returns
# <true>:: If the font is installed
# <false>:: If the font is not instaled
def font_exists?
  ::File.exist?(@current_resource.file)
end

def get_cookbook_font
  r = Chef::Resource::CookbookFile.new(@new_resource.file, run_context)
  r.path(win_friendly_path(::File.join(ENV['TEMP'], @new_resource.file)))
  r.cookbook(cookbook_name.to_s)
  r.run_action(:create)
end

def del_cookbook_font
  r = Chef::Resource::File.new(::File.join(ENV['TEMP'], @new_resource.file), run_context)
  r.run_action(:delete)
end

def install_font
  require 'win32ole'
  fonts_dir = WIN32OLE.new('WScript.Shell').SpecialFolders('Fonts')
  folder = WIN32OLE.new('Shell.Application').Namespace(fonts_dir)
  folder.CopyHere(win_friendly_path(::File.join(ENV['TEMP'], @new_resource.file)))
  Chef::Log.debug("Installing font: #{@new_resource.file}")
end

def action_install
  unless font_exists?
    get_cookbook_font
    install_font
    del_cookbook_font
    new_resource.updated_by_last_action(true)
  else
    Chef::Log.debug("Not installing font: #{@new_resource.file}, font already installed.")
    new_resource.updated_by_last_action(false)
  end
end
