require "spec_helper"

describe Api::CropsController, :type => :controller do
  it "Should list crops." do
    pending "Not done yet"
    FactoryGirl.create_list(:crop, 3)
    get "index", format: :json
  end
end
