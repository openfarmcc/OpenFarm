# frozen_string_literal: true

module GardenCrops
  class DestroyGardenCrop < Mutations::Command
    required do
      model :user
      string :id
      string :garden_id
    end

    def validate
      find_garden_crop
      authorize_user
    end

    def execute
      @garden_crop.destroy
    end

    def authorize_user
      if @garden_crop && (@garden_crop.garden.user != user)
        msg = 'You can only destroy garden crops that belong to your gardens.'
        raise OpenfarmErrors::NotAuthorized, msg
      end
    end

    def find_garden_crop
      @garden_crop = Garden.find(garden_id).garden_crops.find(id)
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a garden_crop with id #{id}."
      add_error :garden_crop, :garden_crop_not_found, msg
    end
  end
end
