require 'spec_helper'

describe 'Announcements' do
  include IntegrationHelper

  it 'shows announcements if they are within the current date span' do
    Announcement.create(message: 'Test Announcement',
                        starts_at: Date.today.prev_day,
                        ends_at: Date.today.next_day)
    visit root_path
    expect(page).to have_content('Test Announcement')
  end

  it 'shows permanent announcements' do
    Announcement.create(message: 'Test Announcement',
                        is_permanent: true)
    visit root_path
    expect(page).to have_content('Test Announcement')
  end
end
