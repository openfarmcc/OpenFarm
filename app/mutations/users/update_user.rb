module Users
  class UpdateUser < Mutations::Command
    required do
      model :user
    end

    optional do
      string :display_name
      string :location
      string :years_experience
      string :mailing_list
      string :units
      string :is_private
    end

    def execute
      set_valid_params
    end

    def set_valid_params
      # TODO: Probably a DRYer way of doing this.
      user.location       = location if location.present?
      user.display_name   = display_name if display_name.present?
      user.mailing_list   = mailing_list if mailing_list.present?
      user.units          = units if units.present?
      user.is_private     = is_private if is_private.present?
      user.save
    end
  end
end
