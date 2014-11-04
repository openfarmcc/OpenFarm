class HomeController < ApplicationController
  def show
    @featured_crops = Crop.desc(:guides_count).limit(9)
  end
end
