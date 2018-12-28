class ReindexGuidesJob < ActiveJob::Base
  queue_as :default

  def perform
    Guide.desc(:popularity_score).each do |guide|
      guide.reindex_async
    end
  rescue => x
    binding.pry
  end
end
