module Users
  class UpdateUser < Mutations::Command

    required do
      string :id
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
        end
      end
      string :featured_image
    end

    def validate
      validate_image
    end

    def execute
      @user = User.find(id)
      if user_setting
        @user.user_setting.update_attributes(user_setting)
      end
      set_image
      @user.update_attributes(user)
      @user.save
      @user
    end

    def validate_image
      if featured_image
        picture = @user.user_setting.featured_image if @user
        outcome = Pictures::CreatePicture.validate(url: featured_image)
        unless outcome.success?
          add_error :images,
                    :bad_format,
                    outcome.errors.message_list.to_sentence
        end
      end
    end

    def set_image
      if featured_image
        @user.user_setting.picture = Picture.new(attachment: open(featured_image))
      end
    end
  end
end
