# frozen_string_literal: true

module Gardens
  class DestroyGarden < Mutations::Command
    required do
      model :user
      string :id
    end

    def validate
      find_garden
      authorize_user
    end

    def execute
      @garden.destroy
    end

    def authorize_user
      if @garden && (@garden.user != user)
        msg = 'You can only destroy gardens that belong to you.'
        raise OpenfarmErrors::NotAuthorized, msg
      end
    end

    def find_garden
      @garden = Garden.find(id)
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a garden with id #{id}."
      add_error :stage, :garden_not_found, msg
    end
  end
end
