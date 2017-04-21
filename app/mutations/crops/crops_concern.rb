module Crops
  module CropsConcern
    def validate_companions
      if attributes[:companions]
        attributes[:companions] = attributes[:companions].uniq
        attributes[:companions].map! do |companion_id|
          # check if companion exists
          Crop.find(companion_id)
        end
      end
    end
  end
end
