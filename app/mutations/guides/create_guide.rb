module Guides
  class CreateGuide < Mutations::Command
    attr_writer :guide

    include Guides::GuidesConcern

    required do
      model :user

      hash :attributes do
        required do
          string :name
        end
        optional do
          string :overview
          string :featured_image
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
    end

    def validate
      validate_practices
      validate_image_url
      validate_crop
    end

    def execute
      @guide ||= Guide.new(attributes)
      @guide.user = user
      @guide.crop = @crop
      set_time_span
      set_featured_image_async
      @guide.save!
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
      crops = Crop.search(crop_name,
                          fields: [{ name: :exact }])
      if crops.count == 0
        crop = Crop.new( name: :crop_name,
                         common_names: [:crop_name,] )
        crop.save
        crop
      else
        crops[0]
      end
    end
  end
end
