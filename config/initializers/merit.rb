# Use this hook to configure merit parameters
Merit.setup { |config| config.orm = :mongoid }

badge_id = 0
[
  { id: (badge_id = badge_id + 1), name: 'kickstarter-backer', description: 'You sponsored OpenFarm on Kickstarter!' },
  { id: (badge_id = badge_id + 1), name: 'guide-creator', description: "You've created at least one Guide!" },
  { id: (badge_id = badge_id + 1), name: 'crop-editor', description: "You've improved our existing crop information!" },
  { id: (badge_id = badge_id + 1), name: 'garden-creator', description: "You've created more than one garden!" },
  { id: (badge_id = badge_id + 1), name: 'crop-creator', description: "You've added a crop to our database!" },
  {
    id: (badge_id = badge_id + 1),
    name: 'gardener',
    description: "You've added a crop or a guide to one of your gardens!"
  }
].each { |badge| Merit::Badge.create! badge }
