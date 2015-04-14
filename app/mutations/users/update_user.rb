module Users
  class UpdateUser < Mutations::Command

    required do
      string :id
      model :current_user, class: 'User'
      hash :user do
        optional do
          string :display_name
          string :mailing_list
          string :help_list
          string :is_private
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
    end

    def validate
      puts "user setting: #{user_setting}"
      validate_user
      validate_favorite_crop
    end

    def execute
      @user = User.find(id)
      set_user_setting
      @user.update_attributes(user)
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
      if @favorite_crop
        puts "setting favorite crop"
        @user.user_setting.favorite_crops = [@favorite_crop]
      end
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

    def validate_user
      # TODO update this to use the Policy
      puts current_user.id, id
      if current_user.id.to_s != id.to_s
        msg = 'You can only update your own profile'
        raise OpenfarmErrors::NotAuthorized, msg
      end
    end
  end
end
