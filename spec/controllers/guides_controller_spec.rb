require 'spec_helper'

describe GuidesController do
  it 'directs to a new page' do
    get 'new'
    expect(response).to render_template(:new)
  end

  it 'renders a show page' do
    guide = FactoryGirl.create(:guide)
    get 'show', id: guide.id
    expect(response).to render_template(:show)
  end

  it 'directs to edit page after successful guide creation'
  
  it 'redirects back to form after unsuccessful crop creation' do
    guide = FactoryGirl.attributes_for(:guide)
    guide[:name] = ''
    post 'create', guide: guide
    expect(response).to render_template(:new)
  end
end
