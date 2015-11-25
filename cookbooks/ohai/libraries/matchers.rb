# encoding: utf-8

if defined?(ChefSpec)
  if ChefSpec.respond_to?(:define_matcher)
    # ChefSpec >= 4.1
    ChefSpec.define_matcher(:ohai_hint)
  elsif defined?(ChefSpec::Runner) &&
        ChefSpec::Runner.respond_to?(:define_runner_method)
    # ChefSpec < 4.1
    ChefSpec::Runner.define_runner_method(:ohai_hint)
  end

  def create_ohai_hint(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:ohai_hint, :create, resource)
  end

  def delete_ohai_hint(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:ohai_hint, :delete, resource)
  end

end
