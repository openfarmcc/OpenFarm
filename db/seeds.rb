require 'factory_girl_rails'
if Rails.env != 'production' # <= Prevent catastrophe
  Mongoid.purge!
  admin = FactoryGirl.create(:user, admin: true,
                             email: 'admin@admin.com',
                             password: 'admin123',
                             password_confirmation: 'admin123')

  FactoryGirl.create(:garden, user: admin)

  # Creating some common test crops
  tomato = FactoryGirl.create(:crop, name: 'Tomato')
  cherry = FactoryGirl.create(:crop, name: 'Cherry')
  FactoryGirl.create(:crop, name: 'Grass')
  FactoryGirl.create(:crop, name: 'Tomato Fern')
  banana = FactoryGirl.create(:crop, name: 'Banana')
  FactoryGirl.create(:crop, name: 'Water Lily')

  # Creating some guides for those crops
  FactoryGirl.create(:guide, user: admin, crop: tomato)
  FactoryGirl.create(:guide, user: admin, crop: cherry)
  FactoryGirl.create(:guide, crop: cherry)
  FactoryGirl.create(:guide, crop: banana)

  water = FactoryGirl.create(:stage_action_option, name: 'Water')
  mulch = FactoryGirl.create(:stage_action_option, name: 'Apply Mulch')
  prepare = FactoryGirl.create(:stage_action_option, name: 'Prepare Soil')
  amend = FactoryGirl.create(:stage_action_option, name: 'Amend Soil')
  fertilize = FactoryGirl.create(:stage_action_option,
                                 name: 'Apply Fertilizer')
  pesticide = FactoryGirl.create(:stage_action_option,
                                 name: 'Apply Pesticide')
  weeds = FactoryGirl.create(:stage_action_option, name: 'Remove Weeds')
  sow = FactoryGirl.create(:stage_action_option, name: 'Sow')
  prune = FactoryGirl.create(:stage_action_option, name: 'Prune')
  thin = FactoryGirl.create(:stage_action_option, name: 'Thin')
  harvest = FactoryGirl.create(:stage_action_option, name: 'Harvest')
  biocontrol = FactoryGirl.create(:stage_action_option,
                                  name: 'Add Biocontrol')
  cover = FactoryGirl.create(:stage_action_option, name: 'Cover')
  graft = FactoryGirl.create(:stage_action_option, name: 'Graft')
  support = FactoryGirl.create(:stage_action_option,
                               name: 'Add Support Structure')
  tap = FactoryGirl.create(:stage_action_option, name: 'Tap')
  pollinate = FactoryGirl.create(:stage_action_option, name: 'Pollinate')
  scar = FactoryGirl.create(:stage_action_option, name: 'Scar')
  stratify = FactoryGirl.create(:stage_action_option, name: 'Stratify')
  train = FactoryGirl.create(:stage_action_option, name: 'Train')

  prep = FactoryGirl.create(:stage_option, name: 'Preparation', order: 0)
  prep.stage_action_options = [water, fertilize, amend, prepare]

  germ = FactoryGirl.create(:stage_option, name: 'Germination', order: 1)
  germ.stage_action_options = [mulch, water, stratify]

  sow = FactoryGirl.create(:stage_option, name: 'Sow', order: 2)
  sow.stage_action_options = [weeds, fertilize, water, sow]

  seed = FactoryGirl.create(:stage_option, name: 'Seedling', order: 3)
  seed.stage_action_options = [weeds, fertilize, water, thin]

  juve = FactoryGirl.create(:stage_option, name: 'Juvenile', order: 4)
  juve.stage_action_options = [weeds, fertilize, water, thin, biocontrol,
                               pesticide, support, train]

  adult = FactoryGirl.create(:stage_option, name: 'Adult', order: 5)
  adult.stage_action_options = [weeds, fertilize, graft, water, biocontrol,
                                pesticide, support]

  flower = FactoryGirl.create(:stage_option, name: 'Flowering', order: 6)
  flower.stage_action_options = [weeds, fertilize, graft, pollinate, prune]

  fruit = FactoryGirl.create(:stage_option, name: 'Fruit', order: 7)
  fruit.stage_action_options = [weeds, harvest, graft, pollinate, prune, scar]

  dormant = FactoryGirl.create(:stage_option, name: 'Dormant', order: 8)
  dormant.stage_action_options = [prune, cover, tap]

  Guide.all.each{ |gde| gde.update_attributes(user: admin) }
end
