require 'factory_girl_rails'
if Rails.env != 'production' # <= Prevent catastrophe
  Mongoid.purge!
  admin = FactoryGirl.create(:user, admin: true,
                             email: 'admin@admin.com',
                             password: 'admin123',
                             password_confirmation: 'admin123')
  FactoryGirl.create(:garden, user: admin)
  FactoryGirl.create_list(:stage, 10)
  FactoryGirl.create_list(:stage_option, 10)
  FactoryGirl.create_list(:requirement_option, 10)
  FactoryGirl.create_list(:requirement, 10)
  FactoryGirl.create_list(:requirement_option, 10)
  Guide.all.each{ |gde| gde.update_attributes(user: admin) }
end
