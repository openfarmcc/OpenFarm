module Api
  class AnnouncementsController < Api::Controller
    skip_before_action :authenticate_from_token!, only: [:hide_announcement]

    # overkill to have this be an announcements controller?
    def hide
      session[:announcement_hide_time] = Time.now
      render nothing: true, status: :no_content
    end
  end
end
