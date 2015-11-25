def why_run_supported?
  true
end

def build_ohai_hint_path
  ::File.join(node['ohai']['hints_path'], "#{new_resource.name}.json")
end

use_inline_resources

action :create do
  if @current_resource.content != new_resource.content
    directory node['ohai']['hints_path'] do
      action :create
      recursive true
    end

    file build_ohai_hint_path do
      action :create
      content JSON.pretty_generate(new_resource.content)
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::OhaiHint.new(new_resource.name)
  if ::File.exist?(build_ohai_hint_path)
    begin
      @current_resource.content(JSON.parse(::File.read(build_ohai_hint_path)))
    rescue JSON::ParserError
      @current_resource.content(nil)
    end
  else
    @current_resource.content(nil)
  end

  @current_resource
end
