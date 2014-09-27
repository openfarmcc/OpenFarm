class RequirementOptionSerializer < ApplicationSerializer
  attributes :default_value, :type, :name, :options

  def options
    object.options.to_a
  end

end
