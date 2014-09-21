class GuideRequirementOptionSerializer < ApplicationSerializer
  attributes :default_value, :type, :name, :options

  # embed :options

  def options
    puts "Hi" + object.options.to_a.to_s
    object.options.to_a
  end

end
