module Guides
  class CreateGuide < Mutations::Command
    attr_writer :guide

    include Guides::GuidesConcern

    required do
      model :user
      string :crop_id
      string :name
    end

    optional do
      string :overview
      string :featured_image
    end

    def guide
      @guide ||= Guide.new
    end

    def validate
      validate_crop
      validate_image_url
    end

    def execute
      set_params
      guide
    end

    def set_params
      guide.crop           = @crop
      guide.name           = name
      guide.user           = user
      guide.overview       = overview if overview
      guide.featured_image = featured_image if featured_image
    end

    def validate_crop
      @crop = Crop.find(crop_id)
    rescue Mongoid::Errors::DocumentNotFound
      add_error :crop_id,
                :crop_not_found,
                "Could not find a crop with id #{crop_id}."
    end

  end
end
