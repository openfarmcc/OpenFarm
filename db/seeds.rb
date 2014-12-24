require 'factory_girl_rails'
if Rails.env != 'production' # <= Prevent catastrophe
  Mongoid.purge!
  admin = FactoryGirl.create(:user, admin: true,
                             email: 'admin@admin.com',
                             password: 'admin123',
                             password_confirmation: 'admin123')

  FactoryGirl.create(:garden, user: admin)

  FactoryGirl.create(:stage_option, name: "Preparation")
  FactoryGirl.create(:stage_option, name: "Germination")
  FactoryGirl.create(:stage_option, name: "Sow")
  FactoryGirl.create(:stage_option, name: "Seedling")
  FactoryGirl.create(:stage_option, name: "Juvenile")
  FactoryGirl.create(:stage_option, name: "Adult")
  FactoryGirl.create(:stage_option, name: "Flowering")
  FactoryGirl.create(:stage_option, name: "Fruit")
  FactoryGirl.create(:stage_option, name: "Dormant")

  FactoryGirl.create(:stage_action_option, name: "Water")
  FactoryGirl.create(:stage_action_option, name: "Apply Mulch")
  FactoryGirl.create(:stage_action_option, name: "Prepare Soil")
  FactoryGirl.create(:stage_action_option, name: "Amend Soil")
  FactoryGirl.create(:stage_action_option, name: "Apply Fertilizer")
  FactoryGirl.create(:stage_action_option, name: "Apply Pesticide")
  FactoryGirl.create(:stage_action_option, name: "Remove Weeds")
  FactoryGirl.create(:stage_action_option, name: "Sow")
  FactoryGirl.create(:stage_action_option, name: "Prune")
  FactoryGirl.create(:stage_action_option, name: "Thin")
  FactoryGirl.create(:stage_action_option, name: "Harvest")
  FactoryGirl.create(:stage_action_option, name: "Add Biocontrol")
  FactoryGirl.create(:stage_action_option, name: "Cover")
  FactoryGirl.create(:stage_action_option, name: "Graft")
  FactoryGirl.create(:stage_action_option, name: "Add Support Structure")
  FactoryGirl.create(:stage_action_option, name: "Tap")
  FactoryGirl.create(:stage_action_option, name: "Pollinate")
  FactoryGirl.create(:stage_action_option, name: "Scar")
  FactoryGirl.create(:stage_action_option, name: "Stratify")
  FactoryGirl.create(:stage_action_option, name: "Train")

  Guide.all.each{ |gde| gde.update_attributes(user: admin) }
end
