#
# Cookbook Name:: ruby_build
# Provider:: ruby
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
#
# Copyright 2011, Fletcher Nichol
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

def load_current_resource
  @rubie        = new_resource.definition
  @prefix_path  = new_resource.prefix_path ||
    "#{node['ruby_build']['default_ruby_base_path']}/#{@rubie}"
end

action :install do
  perform_install
end

action :reinstall do
  perform_install
end

private

def perform_install
  if ruby_installed?
    Chef::Log.debug(
      "ruby_build_ruby[#{@rubie}] is already installed, so skipping")
  else
    install_start = Time.now

    install_ruby_dependencies

    Chef::Log.info(
      "Building ruby_build_ruby[#{@rubie}], this could take a while...")

    rubie       = @rubie        # bypass block scoping issue
    prefix_path = @prefix_path  # bypass block scoping issue
    execute "ruby-build[#{rubie}]" do
      command   %{/usr/local/bin/ruby-build "#{rubie}" "#{prefix_path}"}
      user        new_resource.user         if new_resource.user
      group       new_resource.group        if new_resource.group
      environment new_resource.environment  if new_resource.environment

      action    :nothing
    end.run_action(:run)

    Chef::Log.info("ruby_build_ruby[#{@rubie}] build time was " +
      "#{(Time.now - install_start)/60.0} minutes")
    new_resource.updated_by_last_action(true)
  end
end

def ruby_installed?
  if Array(new_resource.action).include?(:reinstall)
    false
  else
    ::File.exists?("#{@prefix_path}/bin/ruby")
  end
end

def install_ruby_dependencies
  case ::File.basename(new_resource.definition)
  when /^\d\.\d\.\d-/, /^rbx-/, /^ree-/
    pkgs = node['ruby_build']['install_pkgs_cruby']
  when /^jruby-/
    pkgs = node['ruby_build']['install_pkgs_jruby']
  end

  Array(pkgs).each do |pkg|
    package pkg do
      action :nothing
    end.run_action(:install)
  end
end
