# frozen_string_literal: true

module Guides
  class DestroyGuide < Mutations::Command
    required do
      model :user
      string :id
    end

    def validate
      find_guide
      authorize_user
    end

    def execute
      @guide.destroy
    end

    def authorize_user
      if @guide && (@guide.user != user)
        msg = 'You can only destroy guides that belong to you.'
        raise OpenfarmErrors::NotAuthorized, msg
      end
    end

    def find_guide
      @guide = Guide.find(id)
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a guide with id #{id}."
      add_error :stage, :guide_not_found, msg
    end
  end
end
