require 'spec_helper'

SVG = File.read("./spec/fixtures/cantaloupe.svg")

describe Icon do
  it 'has an svg' do
    Icon.reindex
    user = FactoryGirl.create(:user)
    i    = Icon.create!(svg: SVG, description: "Lorem ipsum",
                        name: "cantaloupe",
                        user: user)
    i.reload
    expect(i.name).to eq("cantaloupe")
    expect(i.svg).to eq(SVG)
    expect(i.user).to eq(user)
  end
end
