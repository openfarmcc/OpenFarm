class AnnouncementsController < ApplicationController
  def hide
    session[:announcement_hide_time] = Time.now
    render body: nil, status: :no_content
  end
end
