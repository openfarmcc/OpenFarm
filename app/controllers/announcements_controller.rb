class AnnouncementsController < Api::Controller
  def hide
    session[:announcement_hide_time] = Time.now
    render nothing: true, status: :no_content
  end
end
