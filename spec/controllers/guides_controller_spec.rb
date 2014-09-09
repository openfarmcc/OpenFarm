require 'spec_helper'

describe GuidesController do
  it 'Should direct to a new page' do
    get 'new'
    expect(response).to render_template(:new)
  end

  it 'Should render a show page' do
    guide = FactoryGirl.create(:guide)
    get 'show', id: guide.id
    expect(response).to render_template(:show)
  end

  it 'Should direct to edit page after successful guide creation'
  
  it 'Should redirect back to form after unsuccessful crop creation' do
    guide = FactoryGirl.attributes_for(:guide)
    guide[:name] = ''
    post 'create', guide: guide
    expect(response).to render_template(:new)
  end
end
