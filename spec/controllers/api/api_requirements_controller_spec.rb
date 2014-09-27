require 'spec_helper'

describe Api::RequirementsController, type: :controller do

  include ApiHelpers

  let(:user) { sign_in(user = FactoryGirl.create(:user)) && user }
  let(:guide) { FactoryGirl.create(:guide, user: user) }
  let(:requirement) { FactoryGirl.create(:requirement, guide: user) }

  before do
    @guide = FactoryGirl.create(:guide, name: 'lee\'s mung bean')
  end

  it 'creates requirements' do
    sign_in user
    guide = FactoryGirl.create(:guide, user: user)
    old_length = Requirement.all.length
    data = { name: Faker::Lorem.word,
             required: "#{Faker::Lorem.words(2)}",
             guide_id: guide.id }
    post 'create', data, format: :json
    expect(response.status).to eq(201)
    new_length = Requirement.all.length
    expect(new_length).to eq(old_length + 1)
  end

  it 'deletes requirements' do
    sign_in FactoryGirl.create(:user)
    guide = FactoryGirl.create(:guide, user: user)
    requirement = FactoryGirl.create(:requirement, guide: guide)
    old_length = Requirement.all.length
    delete 'destroy', id: requirement.id, format: :json
    new_length = Requirement.all.length
    expect(new_length).to eq(old_length - 1)
  end

  it 'should return an error when wrong info is passed to create' do
    sign_in FactoryGirl.create(:user)
    data = {
      required: "#{Faker::Lorem.sentences(2)}",
      guide_id: guide.id
    }
    post 'create', data, format: :json
    expect(response.status).to eq(422)
  end

  it 'should show a specific requirements' do
    requirement = FactoryGirl.create(:requirement)
    get 'show', id: requirement.id, format: :json
    expect(response.status).to eq(200)
    expect(json['requirement']['name']).to eq(requirement.name)
  end

  it 'should return a not found error if a guide is not found'

  it 'should update a requirement' do
    sign_in user
    guide = FactoryGirl.create(:guide, user: user)
    requirement = FactoryGirl.create(:requirement, guide: guide)
    put :update, id: requirement.id, required: 'updated'
    expect(response.status).to eq(200)
    requirement.reload
    expect(requirement.required).to eq('updated')
  end

  it 'should not update a requirement on someone elses guide' do
    sign_in FactoryGirl.create(:user)
    guide = FactoryGirl.create(:guide)
    requirement = FactoryGirl.create(:requirement, guide: guide)
    put :update, id: requirement.id, required: 'updated'
    expect(response.status).to eq(422) # WRONG. See TODO in mutation.
    expect(response.body).to include('You can only update requirements that belong to your guides.')
  end

end
