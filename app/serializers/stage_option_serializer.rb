class StageOptionSerializer < ApplicationSerializer
  attributes :default_value, :name, :slug, :description,
             :order

end
