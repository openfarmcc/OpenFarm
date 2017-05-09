# frozen_string_literal: true

class ReindexIconsJob < ActiveJob::Base
  queue_as :default

  def perform
    Icon.all.each(&:reindex_async)
  end
end
