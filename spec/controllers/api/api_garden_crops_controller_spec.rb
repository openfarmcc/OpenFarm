require 'spec_helper'

describe Api::GardenCropsController, type: :controller do
  include ApiHelpers

  describe 'create' do
    before do
      @user = FactoryGirl.create :user
      sign_in @user
    end
    it 'should create garden crops' do
      guide = FactoryGirl.create(:guide)
      garden = FactoryGirl.create(:garden, user: @user)
      data = { quantity: rand(100),
               stage: "#{Faker::Lorem.word}",
               sowed: "#{Faker::Date.between(2.days.ago, Date.today)}", 
               guide_id: guide.id }
      post "/api/gardens/#{garden.id}/garden_crops/", data, format: :json
    end

    it 'should need a guide to create a garden crop' do

    end
  end
end
