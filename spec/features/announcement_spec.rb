require 'spec_helper'

describe 'Announcements' do
  include IntegrationHelper

  it 'shows announcements if they are within the current date span' do
    # Announcement.create(message: 'Test Announcement',
    #                     starts_at: Time.zone.now.to_date.prev_day,
    #                     ends_at: Time.zone.now.to_date.next_day)
    # visit root_path
    # expect(page).to have_content('Test Announcement')
  end

  it 'shows permanent announcements' do
    Announcement.create(message: 'Test Announcement',
                        is_permanent: true)
    visit root_path
    expect(page).to have_content('Test Announcement')
  end

  it 'shows announcements that have been updated since the hide time' do
    # announcement = Announcement.create(message: 'Test Announcement',
    #                     starts_at: Time.zone.now.to_date.prev_day,
    #                     ends_at: Time.zone.now.to_date.next_day)
    # visit root_path
    # click_link '×'
    # visit root_path
    # expect(page).not_to have_content('Test Announcement')
    # announcement.message = 'Hi'
    # announcement.save
    # visit root_path
    # expect(page).to have_content('Hi')
  end
end
