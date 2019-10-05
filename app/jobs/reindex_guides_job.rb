class ReindexGuidesJob < ActiveJob::Base
  queue_as :default

  def perform
    Guide.desc(:popularity_score).each(&:reindex)
  end
end
