use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

action :set do
  if @current_resource.exists
    Chef::Log.info "#{@new_resource} already exists - nothing to do."
  else
    execute "#{config_cmd} #{new_resource.key} \"#{new_resource.value}\"" do
      cwd new_resource.path
      user new_resource.user
      group new_resource.user
      environment cmd_env
      Chef::Log.info "#{@new_resource} created."
    end
  end
end

def initialize(*args)
  super

  @run_context.include_recipe 'git'
end

def load_current_resource
  @current_resource = Chef::Resource::GitConfig.new(@new_resource.name)
  @current_resource.exists = true if config == new_resource.value
end

def config_cmd
  "git config --#{new_resource.scope}"
end

def cmd_env
  new_resource.user ? { 'USER' => new_resource.user, 'HOME' => ::Dir.home(new_resource.user) } : nil
end

def config
  cmd = [config_cmd, new_resource.key].join(' ')
  git_config = Mixlib::ShellOut.new(cmd, user: new_resource.user, group: new_resource.user, cwd: new_resource.path, env: cmd_env)
  Chef::Log.debug("Current config cmd: #{git_config.inspect}")
  git_config.run_command.stdout.chomp
end
