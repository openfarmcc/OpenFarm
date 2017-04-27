module ApplicationHelper
  def load_generic_plant_icon
    return h File.read(Rails.root.join("app", "assets", "images", "generic-plant.svg"))
  end
end
