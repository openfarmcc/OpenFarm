require 'factory_bot_rails'
if Rails.env != 'production' # <= Prevent catastrophe
  Mongoid.purge!
  admin = FactoryBot.create(:user, admin: true,
                             email: 'admin@admin.com',
                             password: 'admin123',
                             password_confirmation: 'admin123',
                             confirmed_at: Date.today)

  FactoryBot.create(:garden, user: admin)

  # Creating some common test crops
  tomato = FactoryBot.create(:crop, name: 'Tomato')
  cherry = FactoryBot.create(:crop, name: 'Cherry')
  FactoryBot.create(:crop, name: 'Grass')
  FactoryBot.create(:crop, name: 'Tomato Fern')
  banana = FactoryBot.create(:crop, name: 'Banana')
  FactoryBot.create(:crop, name: 'Water Lily')

  # Creating some guides for those crops
  FactoryBot.create(:guide, user: admin, crop: tomato)
  FactoryBot.create(:guide, user: admin, crop: cherry)
  FactoryBot.create(:guide, crop: cherry)
  FactoryBot.create(:guide, crop: banana)

  water = FactoryBot.create(:stage_action_option, name: 'Water')
  mulch = FactoryBot.create(:stage_action_option, name: 'Apply Mulch')
  prepare = FactoryBot.create(:stage_action_option, name: 'Prepare Soil')
  amend = FactoryBot.create(:stage_action_option, name: 'Amend Soil')
  fertilize = FactoryBot.create(:stage_action_option,
                                 name: 'Apply Fertilizer')
  pesticide = FactoryBot.create(:stage_action_option,
                                 name: 'Apply Pesticide')
  weeds = FactoryBot.create(:stage_action_option, name: 'Remove Weeds')
  sow = FactoryBot.create(:stage_action_option, name: 'Sow')
  prune = FactoryBot.create(:stage_action_option, name: 'Prune')
  thin = FactoryBot.create(:stage_action_option, name: 'Thin')
  harvest = FactoryBot.create(:stage_action_option, name: 'Harvest')
  biocontrol = FactoryBot.create(:stage_action_option,
                                  name: 'Add Biocontrol')
  cover = FactoryBot.create(:stage_action_option, name: 'Cover')
  graft = FactoryBot.create(:stage_action_option, name: 'Graft')
  support = FactoryBot.create(:stage_action_option,
                               name: 'Add Support Structure')
  tap = FactoryBot.create(:stage_action_option, name: 'Tap')
  pollinate = FactoryBot.create(:stage_action_option, name: 'Pollinate')
  scar = FactoryBot.create(:stage_action_option, name: 'Scar')
  stratify = FactoryBot.create(:stage_action_option, name: 'Stratify')
  train = FactoryBot.create(:stage_action_option, name: 'Train')

  # Seed the details for each guide.
  FactoryBot.create(:detail_option,
                     name: 'Greenhouse',
                     category: 'environment')
  FactoryBot.create(:detail_option, name: 'Potted', category: 'environment')
  FactoryBot.create(:detail_option, name: 'Inside', category: 'environment')
  FactoryBot.create(:detail_option, name: 'Outside', category: 'environment')

  FactoryBot.create(:detail_option, name: 'Loam', category: 'soil')
  FactoryBot.create(:detail_option, name: 'Clay', category: 'soil')

  FactoryBot.create(:detail_option, name: 'Full Sun', category: 'light')
  FactoryBot.create(:detail_option, name: 'Partial Sun', category: 'light')
  FactoryBot.create(:detail_option, name: 'Shaded', category: 'light')
  FactoryBot.create(:detail_option, name: 'Indirect Light', category: 'light')

  FactoryBot.create(:detail_option, name: 'Organic', category: 'practices')
  FactoryBot.create(:detail_option, name: 'Hydroponic', category: 'practices')
  FactoryBot.create(:detail_option, name: 'Intensive', category: 'practices')
  FactoryBot.create(:detail_option,
                     name: 'Conventional',
                     category: 'practices')
  FactoryBot.create(:detail_option,
                     name: 'Permaculture',
                     category: 'practices')

  prep = FactoryBot.create(:stage_option, name: 'Preparation', order: 0)
  prep.stage_action_options = [water, fertilize, amend, prepare]

  germ = FactoryBot.create(:stage_option, name: 'Germination', order: 1)
  germ.stage_action_options = [mulch, water, stratify]

  sow = FactoryBot.create(:stage_option, name: 'Sow', order: 2)
  sow.stage_action_options = [weeds, fertilize, water, sow]

  seed = FactoryBot.create(:stage_option, name: 'Seedling', order: 3)
  seed.stage_action_options = [weeds, fertilize, water, thin]

  juve = FactoryBot.create(:stage_option, name: 'Juvenile', order: 4)
  juve.stage_action_options = [weeds, fertilize, water, thin, biocontrol,
                               pesticide, support, train]

  adult = FactoryBot.create(:stage_option, name: 'Adult', order: 5)
  adult.stage_action_options = [weeds, fertilize, graft, water, biocontrol,
                                pesticide, support]

  flower = FactoryBot.create(:stage_option, name: 'Flowering', order: 6)
  flower.stage_action_options = [weeds, fertilize, graft, pollinate, prune]

  fruit = FactoryBot.create(:stage_option, name: 'Fruit', order: 7)
  fruit.stage_action_options = [weeds, harvest, graft, pollinate, prune, scar]

  dormant = FactoryBot.create(:stage_option, name: 'Dormant', order: 8)
  dormant.stage_action_options = [prune, cover, tap]

  Guide.all.each{ |gde| gde.update_attributes(user: admin) }
end
