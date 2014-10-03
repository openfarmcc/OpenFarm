require 'factory_girl_rails'
if Rails.env != 'production'# <= Prevent catastrophe
  Mongoid.purge!
  FactoryGirl.create(:user, admin: true,
                            email: 'admin@admin.com',
                            password: 'admin123',
                            password_confirmation: 'admin123')
  FactoryGirl.create_list(:crop, 40)
end
