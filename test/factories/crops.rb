# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :crop do
    name             'Common Horseradish'
    binomial_name    'Armoracia rusticana'
    description      'Horseradish (Armoracia rusticana, syn. Cochlearia armoracia) is a perennial plant of the Brassicaceae family (which also includes mustard, wasabi, broccoli, and cabbage). The plant is probably native to southeastern Europe and western Asia. It is now popular around the world. It grows up to 1.5 meters (5 feet) tall, and is cultivated primarily for its large, white, tapered root. Harvest after one year.'
    sun_requirements 'full'
    sowing_method    'direct sow'
    spread           30
    days_to_maturity 150
    row_spacing      12
    height           22
  end
end
