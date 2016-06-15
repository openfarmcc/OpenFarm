module Guides
  class CreateGuide < Mutations::Command
    attr_writer :guide
    include PicturesMixin
    include Guides::GuidesConcern

    required do
      model :user

      hash :attributes do
        required do
          string :name
        end
        optional do
          string :overview
          string :location
          array :practices
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
      string :crop_id
      string :crop_name
      array :images, class: Hash, arrayize: true
    end

    def validate
      validate_practices
      validate_images images
      validate_crop
    end

    def execute
      @guide ||= Guide.new(attributes)
      @guide.user = user
      @guide.crop = @crop
      @guide.save!
      set_images images, @guide
      set_time_span
      @guide.save!
      @guide.reload
      @guide
    end

    def validate_crop
      if crop_id
        @crop = Crop.find(crop_id)
      else
        @crop = check_if_crop_exists
      end
    rescue Mongoid::Errors::DocumentNotFound
      if crop_name
        @crop = check_if_crop_exists
      else
        msg = "Could not find a crop with id #{crop_id} or name #{crop_name}."
        add_error :crop_id, :crop_not_found, msg
      end
    end

    private

    def check_if_crop_exists
      crops = Crop.where(name: crop_name)
      if crops.count == 0
        crop = Crop.new(name: crop_name,
                        common_names: [crop_name,])
        crop.save
        crop
      else
        crops[0]
      end
    end
  end
end
