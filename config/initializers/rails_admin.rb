# frozen_string_literal: true
# Why? https://github.com/kaminari/kaminari/issues/886
require 'kaminari/models/array_extension'

RailsAdmin.config do |config|
  config.current_user_method do
    if current_user && current_user.admin?
      current_user
    else
      flash[:notice] = 'I told you kids to get out of here!'
      redirect_to '/'
      nil
    end
  end
  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
  end

  config.model 'Announcement' do
    edit do
      include_fields :starts_at, :ends_at, :is_permanent
      field :message, :text
    end
  end
end
