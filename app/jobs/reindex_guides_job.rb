class ReindexGuidesJob < ActiveJob::Base
  queue_as :default

  def perform
    Guide.desc(:popularity_score).each do |guide|
      guide.reindex
    end
  end
end
