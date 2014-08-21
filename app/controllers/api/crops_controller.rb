module Api
  class CropsController < Api::Controller
    def index
      #TODO: Add querying
      respond_with(Crop.all.limit(100))
    end
  end
end