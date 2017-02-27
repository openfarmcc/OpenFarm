class ReindexIconsJob < ActiveJob::Base
  queue_as :default

  def perform
    Icon.all.each { |icon| icon.reindex_async }
  end
end
