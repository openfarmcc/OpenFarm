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
    end

    def execute
      @user = User.find(id)
      if user_setting
        @user.user_setting.update_attributes(user_setting)
      end
      @user.update_attributes(user)
      @user.save
    end
  end
end
