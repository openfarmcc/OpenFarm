require 'spec_helper'

describe Api::RequirementsController, type: :controller do
  # include ApiHelpers

  # let!(:user) { sign_in(user = FactoryGirl.create(:user)) && user }
  # let(:guide) { FactoryGirl.create(:guide, user: user) }

  # before do
  #   @guide = FactoryGirl.create(:guide, name: 'lee\'s mung bean')
  # end

  # it 'creates requirements' do
  #   guide = FactoryGirl.create(:guide, user: user)
  #   old_length = Requirement.all.length
  #   data = { name: Faker::Lorem.word,
  #            required: "#{Faker::Lorem.words(2)}",
  #            guide_id: guide.id }
  #   post :create, data, format: :json
  #   expect(response.status).to eq(201)
  #   new_length = Requirement.all.length
  #   expect(new_length).to eq(old_length + 1)
  # end

  # it 'deletes requirements' do
  #   guide = FactoryGirl.create(:guide, user: user)
  #   requirement = FactoryGirl.create(:requirement, guide: guide)
  #   old_length = Requirement.all.length
  #   delete 'destroy', id: requirement.id, format: :json
  #   new_length = Requirement.all.length
  #   expect(new_length).to eq(old_length - 1)
  # end

  # it 'should return an error when wrong info is passed to create' do
  #   # FIXME reword this to better describe whats going on or make assertions
  # on
  #   # the response body text.
  #   data = {
  #     required: "#{Faker::Lorem.sentences(2)}",
  #     guide_id: guide.id
  #   }
  #   post :create, data, format: :json
  #   expect(response.status).to eq(422)
  # end

  # it 'only allows you to edit your requirements' do
  #   put :update, id: FactoryGirl.create(:requirement).id, required: 'updated'
  #   expect(response.status).to eq(401)
  #   expect(json['error']).to include(
  #     'You can only update requirements that belong to your guides.')
  # end

  # it 'should show a specific requirements' do
  #   requirement = FactoryGirl.create(:requirement)
  #   get :show, id: requirement.id, format: :json
  #   expect(response.status).to eq(200)
  #   expect(json['requirement']['name']).to eq(requirement.name)
  # end

  # it 'should return a not found error if a guide is not found' do
  #   post :create, name: 'sunlight', required: true, guide_id: 1
  #   expect(json["guide"]).to eq("Could not find a guide with id 1.")
  #   expect(response.status).to eq(422)
  # end

  # it 'does not allow adding requirements to other peoples guides' do
  #   data = { name: 'sunlight',
  #            required: true,
  #            guide_id: FactoryGirl.create(:guide) }
  #   post :create, data
  #   expect(json['error']).to include(
  #     "cant create requirements for guides you did not create")
  #   expect(response.status).to eq(401)
  # end

  # it 'should update a requirement' do
  #   guide = FactoryGirl.create(:guide, user: user)
  #   requirement = FactoryGirl.create(:requirement, guide: guide)
  #   put :update, id: requirement.id, required: 'updated'
  #   expect(response.status).to eq(200)
  #   requirement.reload
  #   expect(requirement.required).to eq('updated')
  # end

  # it 'should not update a requirement on someone elses guide' do
  #   guide = FactoryGirl.create(:guide)
  #   requirement = FactoryGirl.create(:requirement, guide: guide)
  #   put :update, id: requirement.id, required: 'updated'
  #   expect(response.status).to eq(401)
  #   expect(response.body).to include(
  #     'You can only update requirements that belong to your guides.')
  # end

  # it 'only destroys requirements owned by the user' do
  #   delete :destroy, id: FactoryGirl.create(:requirement)
  #   expect(json['error']).to include(
  #     "can only destroy requirements that belong to your guides.")
  #   expect(response.status).to eq(401)
  # end

  # it 'handles deletion of unknown requirements' do
  #   delete :destroy, id: 1
  #   expect(json['requirement'])
  #     .to eq("Could not find a requirement with id 1.")
  #   expect(response.status).to eq(422)
  # end
end
