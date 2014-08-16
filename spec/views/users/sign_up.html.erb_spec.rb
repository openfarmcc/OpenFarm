require "spec_helper"

describe "users/sign_up.html.erb" do
  it "displays the sign up form" do
    render
    rendered.should contain("Display Name")
  end
  it "displays the sign up perks" do
    render
    rendered.should contain("Guides")
  end
end