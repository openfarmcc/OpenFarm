module Guides
  class UpdateGuide < Mutations::Command
    include PicturesMixin
    include Guides::GuidesConcern

    required do
      model :user
      model :guide
      hash :attributes do
        optional do
          string :overview
          string :location
          string :name
          array :practices
          boolean :draft
          # string :featured_image
          # There has to be a better way to do this.
          hash :time_span do
            optional do
              string :start_event
              string :start_event_format
              string :start_offset
              string :start_offset_amount
              string :length
              string :length_units
              string :end_event
              string :end_event_format
              string :end_offset_units
              string :end_offset_amount
            end
          end
        end
      end
    end

    optional do
      array :images, class: Hash, arrayize: true
    end

    def validate
      @guide = guide

      validate_time_span
      validate_permissions
      validate_practices
      validate_images images, @guide
    end

    def execute
      @guide.update(attributes.select {|k| k != 'featured_image'})
      set_time_span
      set_images images, @guide
      set_empty_practices
      @guide.save
      @guide
    end

    private

    def set_empty_practices
      if attributes[:practices] == nil
        @guide.practices = []
      end
    end

    def validate_permissions
      if @guide.user != user
        msg = 'You can only modify guides that you created.'
        raise OpenfarmErrors::NotAuthorized, msg
      end
    end
  end
end
