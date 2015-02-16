class ReindexGuidesJob < ActiveJob::Base
  queue_as :default

  def perform
    Guide.reindex
  end
end
