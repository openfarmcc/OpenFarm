class HomeController < ApplicationController
  def show

    sorted_crops = []
    9.times do |t|
      c = Crop.new
      c.name = "Crop #{t}"
      c.image = 'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTph8uEWmNPYjYI_ufueeUVQNladOLRt-eKab2wkU_uua-ZdZUv'
      sorted_crops.push c
    end

    # sorted_crops = Crop.sort {|c| c.guides.count}
    @featured_crops = sorted_crops.take(9);
  end
end
