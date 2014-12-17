module Guides
  class UpdateGuide < Mutations::Command
    include Guides::GuidesConcern

    required do
      string :id
      model :user
      model :guide
    end

    optional do
      string :overview
      string :location
      string :name
      array :practices
      string :featured_image
    end

    def validate
      validate_permissions
      validate_image_url
    end

    def execute
      set_valid_params
      guide
    end

    private

    def validate_permissions
      if guide.user != user
        msg = 'You can only modify guides that you created.'
        raise OpenfarmErrors::NotAuthorized, msg
      end
    end

    def set_valid_params
      # TODO: Probably a DRYer way of doing this.
      guide.overview       = overview if overview.present?
      guide.location       = location if location.present?
      guide.name           = name if name.present?
      guide.practices      = practices if practices.present?
      guide.save
      set_featured_image_async
    end
  end
end
