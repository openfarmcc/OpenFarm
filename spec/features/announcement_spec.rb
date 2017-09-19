require 'spec_helper'

describe 'Announcements' do
  include IntegrationHelper
  # Pending tests
  it 'shows announcements if they are within the current date span' do
    Announcement.create(message: 'Test Announcement',
                        starts_at: Time.zone.now.to_date.prev_day,
                        ends_at: Time.zone.now.to_date.next_day)
    visit root_path
    # Pending tests
    
  end

  it 'shows permanent announcements' do
    Announcement.create(message: 'Test Announcement',
                        is_permanent: true)
    visit root_path
    # Pending tests
  end

end
