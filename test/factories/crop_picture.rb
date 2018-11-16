cat = File.open('spec/fixtures/cat.jpg')
FactoryBot.define do
  factory :crop_picture, class: Picture do
    attachment    { cat }
    photographic  { FactoryBot.build(:crop) }
  end
end
