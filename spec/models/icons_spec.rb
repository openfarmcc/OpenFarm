require 'spec_helper'

SVG = File.read("./spec/fixtures/cantaloupe.svg")

describe Icon do
  it 'has an svg' do
    i = Icon.create!(svg: SVG, description: "Lorem ipsum", name: "cantaloupe")
    i.reload
    expect(i.name).to eq("cantaloupe")
  end
end
