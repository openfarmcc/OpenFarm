# frozen_string_literal: true

module ApplicationHelper
  DEFAULT_ICON_PATH = Rails.root.join('app', 'assets', 'images', 'generic-plant.svg')
  DEFAULT_ICON = File.read(DEFAULT_ICON_PATH)

  def load_generic_plant_icon
    raw(DEFAULT_ICON)
  end
end
