#
# Cookbook Name:: ruby_build
# Recipe:: default
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

class Chef::Recipe
  # mix in recipe helpers
  include Chef::RubyBuild::RecipeHelpers
end

git_url = node['ruby_build']['git_url']
git_ref = node['ruby_build']['git_ref']
upgrade_strategy  = build_upgrade_strategy(node['ruby_build']['upgrade'])

cache_path  = Chef::Config['file_cache_path']
src_path    = "#{cache_path}/ruby-build"

unless mac_with_no_homebrew
  Array(node['ruby_build']['install_pkgs']).each do |pkg|
    package pkg
  end

  Array(node['ruby_build']['install_git_pkgs']).each do |pkg|
    package pkg do
      not_if "git --version >/dev/null"
    end
  end
end

execute "Install ruby-build" do
  cwd       src_path
  command   %{./install.sh}

  action    :nothing
  not_if do
    ::File.exists?("/usr/local/bin/ruby-build") && upgrade_strategy == "none"
  end
end

directory ::File.dirname(src_path) do
  recursive true
end

git src_path do #~FC043 exception to support AWS OpsWorks using an older Chef
  repository  git_url
  reference   git_ref

  if upgrade_strategy == "none"
    action    :checkout
  else
    action    :sync
  end

  notifies :run, resources(:execute => "Install ruby-build"), :immediately
end
