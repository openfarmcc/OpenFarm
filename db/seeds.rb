require 'factory_girl_rails'
Mongoid.purge!
FactoryGirl.create(:user, admin: true,
                          email: 'admin@admin.com',
                          password: 'admin123',
                          password_confirmation: 'admin123')
FactoryGirl.create_list(:crop, 10)
FactoryGirl.create_list(:crop, 10)
FactoryGirl.create_list(:crop, 10)
FactoryGirl.create_list(:crop, 10)

# TODO: add seeds for GuideRequirementOption
GuideRequirementOption.create(
  default_value: "Full Sun",
  type: "select",
  name: "Sun / Shade",
  options: ['Full Sun', 'Partial Sun', 'Shaded']
  )

GuideRequirementOption.create(
  default_value: 7.5,
  type: "range",
  name: "pH",
  options: [0.0, 12.0, 0.5]
  )
