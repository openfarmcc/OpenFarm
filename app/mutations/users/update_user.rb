module Users
  class UpdateUser < Mutations::Command
    include PicturesMixin

    required do
      string :id
      model :current_user, class: 'User'
      hash :attributes do
        optional do
          string :display_name
          string :mailing_list
          string :help_list
          string :is_private
          array :favorited_guide_ids
        end
      end
    end
    optional do
      hash :user_setting do
        optional do
          string :location
          string :years_experience
          string :units
          string :favorite_crop
        end
      end
      array :pictures, class: Hash, arrayize: true
    end

    def validate
      validate_user
      validate_favorite_crop
      validate_favorite_guides
      validate_images pictures, current_user.user_setting
    end

    def execute
      @user = User.find(id)
      set_user_setting
      set_images pictures, current_user.user_setting
      set_favorited_guides
      @user.update_attributes(attributes)
      @user.save
      @user
    end

    protected

    def set_user_setting
      if user_setting
        set_favorite_crop
        @user.user_setting.update_attributes(user_setting)
        @user.user_setting.save
      end
    end

    def set_favorite_crop
      @user.user_setting.favorite_crops = [@favorite_crop] if @favorite_crop
    end

    def validate_favorite_crop
      if user_setting && user_setting[:favorite_crop]
        # remove favorite crop from hash, causin' problems
        @favorite_crop = [Crop.find(user_setting.delete('favorite_crop'))]
      end
    rescue Mongoid::Errors::DocumentNotFound
      msg = "Could not find a crop with id #{user_setting[:favorite_crop]}"
      add_error user_setting[:favorite_crop], :crop_not_found, msg
    end

    def validate_favorite_guides
      current_guide_id = ''
      unless attributes[:favorited_guide_ids].nil?
        @favorited_guides = []
        attributes[:favorited_guide_ids].uniq.each do |guide_id|
          current_guide_id = guide_id
          guide = Guide.find(guide_id)
          @favorited_guides.push(guide) unless @favorited_guides.include? guide
        end
        attributes.delete 'favorited_guide_ids'
      end
    rescue Mongoid::Errors::DocumentNotFound => e
      # How disappointing that Mongoid::Errors:DocumentNotFound doesn't
      # return a reference to the ID looked for.
      msg = "There is no guide with id #{current_guide_id}"
      add_error 'favorited_guide_ids', :guide_not_found, msg
    end

    def set_favorited_guides
      @user.favorited_guides = @favorited_guides if @favorited_guides
    end

    def validate_user
      # TODO update this to use the Policy
      if current_user.id.to_s != id.to_s
        msg = 'You can only update your own profile'
        raise OpenfarmErrors::NotAuthorized, msg
      end
    end
  end
end
