#
# Author:: Paul Mooring (<paul@chef.io>)
# Cookbook Name:: windows
# Provider:: task
#
# Copyright:: 2012-2015, Chef Software, Inc.
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
include Chef::Mixin::ShellOut

use_inline_resources

action :create do
  if @current_resource.exists && (!(task_need_update? || @new_resource.force))
    Chef::Log.info "#{@new_resource} task already exists - nothing to do"
  else
    validate_user_and_password
    validate_interactive_setting
    validate_create_day

    schedule = @new_resource.frequency == :on_logon ? 'ONLOGON' : @new_resource.frequency
    frequency_modifier_allowed = [:minute, :hourly, :daily, :weekly, :monthly]
    options = {}
    options['F'] = '' if @new_resource.force || task_need_update?
    options['SC'] = schedule
    options['MO'] = @new_resource.frequency_modifier if frequency_modifier_allowed.include?(@new_resource.frequency)
    options['SD'] = @new_resource.start_day unless @new_resource.start_day.nil?
    options['ST'] = @new_resource.start_time unless @new_resource.start_time.nil?
    options['TR'] = "\"#{@new_resource.command}\" "
    options['RU'] = @new_resource.user
    options['RP'] = @new_resource.password if use_password?
    options['RL'] = 'HIGHEST' if @new_resource.run_level == :highest
    options['IT'] = '' if @new_resource.interactive_enabled
    options['D'] = @new_resource.day if @new_resource.day

    run_schtasks 'CREATE', options
    new_resource.updated_by_last_action true
    Chef::Log.info "#{@new_resource} task created"
  end
end

action :run do
  if @current_resource.exists
    if @current_resource.status == :running
      Chef::Log.info "#{@new_resource} task is currently running, skipping run"
    else
      run_schtasks 'RUN'
      new_resource.updated_by_last_action true
      Chef::Log.info "#{@new_resource} task ran"
    end
  else
    Chef::Log.debug "#{@new_resource} task doesn't exists - nothing to do"
  end
end

action :change do
  if @current_resource.exists
    validate_user_and_password
    validate_interactive_setting

    options = {}
    options['TR'] = "\"#{@new_resource.command}\" " if @new_resource.command
    options['RU'] = @new_resource.user if @new_resource.user
    options['RP'] = @new_resource.password if @new_resource.password
    options['SD'] = @new_resource.start_day unless @new_resource.start_day.nil?
    options['ST'] = @new_resource.start_time unless @new_resource.start_time.nil?
    options['IT'] = '' if @new_resource.interactive_enabled

    run_schtasks 'CHANGE', options
    new_resource.updated_by_last_action true
    Chef::Log.info "Change #{@new_resource} task ran"
  else
    Chef::Log.debug "#{@new_resource} task doesn't exists - nothing to do"
  end
end

action :delete do
  if @current_resource.exists
    # always need to force deletion
    run_schtasks 'DELETE', 'F' => ''
    new_resource.updated_by_last_action true
    Chef::Log.info "#{@new_resource} task deleted"
  else
    Chef::Log.debug "#{@new_resource} task doesn't exists - nothing to do"
  end
end

action :end do
  if @current_resource.exists
    if @current_resource.status != :running
      Chef::Log.debug "#{@new_resource} is not running - nothing to do"
    else
      run_schtasks 'END'
      @new_resource.updated_by_last_action true
      Chef::Log.info "#{@new_resource} task ended"
    end
  else
    Chef::Log.fatal "#{@new_resource} task doesn't exist - nothing to do"
    fail Errno::ENOENT, "#{@new_resource}: task does not exist, cannot end"
  end
end

action :enable do
  if @current_resource.exists
    if @current_resource.enabled
      Chef::Log.debug "#{@new_resource} already enabled - nothing to do"
    else
      run_schtasks 'CHANGE', 'ENABLE' => ''
      @new_resource.updated_by_last_action true
      Chef::Log.info "#{@new_resource} task enabled"
    end
  else
    Chef::Log.fatal "#{@new_resource} task doesn't exist - nothing to do"
    fail Errno::ENOENT, "#{@new_resource}: task does not exist, cannot enable"
  end
end

action :disable do
  if @current_resource.exists
    if @current_resource.enabled
      run_schtasks 'CHANGE', 'DISABLE' => ''
      @new_resource.updated_by_last_action true
      Chef::Log.info "#{@new_resource} task disabled"
    else
      Chef::Log.debug "#{@new_resource} already disabled - nothing to do"
    end
  else
    Chef::Log.debug "#{@new_resource} task doesn't exist - nothing to do"
  end
end

def load_current_resource
  @current_resource = Chef::Resource::WindowsTask.new(@new_resource.name)
  @current_resource.task_name(@new_resource.task_name)

  pathed_task_name = @new_resource.task_name[0, 1] == '\\' ? @new_resource.task_name : @new_resource.task_name.prepend('\\')
  task_hash = load_task_hash(@current_resource.task_name)
  if task_hash[:TaskName] == pathed_task_name
    @current_resource.exists = true
    @current_resource.status = :running if task_hash[:Status] == 'Running'
    if task_hash[:ScheduledTaskState] == 'Enabled'
      @current_resource.enabled = true
    end
    @current_resource.cwd(task_hash[:Folder])
    @current_resource.command(task_hash[:TaskToRun])
    @current_resource.user(task_hash[:RunAsUser])
  end if task_hash.respond_to? :[]
end

private

def run_schtasks(task_action, options = {})
  cmd = "schtasks /#{task_action} /TN \"#{@new_resource.task_name}\" "
  options.keys.each do |option|
    cmd += "/#{option} #{options[option]} "
  end
  Chef::Log.debug('running: ')
  Chef::Log.debug("    #{cmd}")
  shell_out!(cmd, returns: [0])
end

def task_need_update?
  # gsub needed as schtasks converts single quotes to double quotes on creation
  @current_resource.command != @new_resource.command.tr("'", "\"") ||
    @current_resource.user != @new_resource.user
end

def load_task_hash(task_name)
  Chef::Log.debug 'looking for existing tasks'

  # we use shell_out here instead of shell_out! because a failure implies that the task does not exist
  output = shell_out("schtasks /Query /FO LIST /V /TN \"#{task_name}\"").stdout
  if output.empty?
    task = false
  else
    task = {}

    output.split("\n").map! do |line|
      line.split(':', 2).map!(&:strip)
    end.each do |field|
      if field.is_a?(Array) && field[0].respond_to?(:to_sym)
        task[field[0].gsub(/\s+/, '').to_sym] = field[1]
      end
    end
  end

  task
end

SYSTEM_USERS = ['NT AUTHORITY\SYSTEM', 'SYSTEM', 'NT AUTHORITY\LOCALSERVICE', 'NT AUTHORITY\NETWORKSERVICE']

def validate_user_and_password
  if @new_resource.user && use_password?
    if @new_resource.password.nil?
      Chef::Log.fatal "#{@new_resource.task_name}: Can't specify a non-system user without a password!"
    end
  end
end

def validate_interactive_setting
  if @new_resource.interactive_enabled && @new_resource.password.nil?
    Chef::Log.fatal "#{new_resource} did not provide a password when attempting to set interactive/non-interactive."
  end
end

def validate_create_day
  return unless @new_resource.day
  unless [:weekly, :monthly].include?(@new_resource.frequency)
    fail 'day attribute is only valid for tasks that run weekly or monthly'
  end
  if @new_resource.day.is_a? String
    days = @new_resource.day.split(',')
    days.each do |day|
      unless ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun', '*'].include?(day.strip.downcase)
        fail 'day attribute invalid.  Only valid values are: MON, TUE, WED, THU, FRI, SAT, SUN and *.  Multiple values must be separated by a comma.'
      end
    end
  end
end

def use_password?
  @use_password ||= !SYSTEM_USERS.include?(@new_resource.user.upcase)
end
