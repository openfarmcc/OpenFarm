require "spec_helper"

describe "User sessions" do
  include IntegrationHelper
  let(:user) { FactoryGirl.create(:user) }

  it "logs in" do
    pending("do this next")
    visit root_path
    click_link "Create an Account"
  end

  it "logs out" do
    login_as user
    visit root_path
    click_link "Logout"
    see("Signed out successfully.")
  end

end
