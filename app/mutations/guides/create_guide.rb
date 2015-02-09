module Guides
  class CreateGuide < Mutations::Command
    attr_writer :guide

    include Guides::GuidesConcern
    # TODO: refactor to use a hash.

    required do
      model :user
      string :crop_id

      hash :attributes do
        required do
          string :name
        end
        optional do
          string :overview
          string :featured_image
          string :location
          array :practices
          hash :time_span
        end
      end
    end

    optional do
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

    def validate
      validate_practices
      validate_crop
      validate_image_url
    end

    def execute
      @guide ||= Guide.new(attributes)
      @guide.user = user
      @guide.crop = @crop
      set_time_span
      set_featured_image_async
      @guide.save
      @guide
    end

    def validate_practices
      if attributes[:practices]
        attributes[:practices].each do |p|
          unless p.is_a? String
            msg = "#{p} is not a valid practice."
            add_error :practices, :invalid, msg
          end
        end
      end
    end

    def validate_crop
      @crop = Crop.find(crop_id)
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a crop with id #{crop_id}."
      add_error :crop_id, :crop_not_found, msg
    end
  end
end
