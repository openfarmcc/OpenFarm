require "spec_helper"

describe ReindexGuidesJob do
  it "reindexes guides" do
    Guide.collection.drop
    FactoryBot.create(:guide)
    expect_any_instance_of(Guide).to receive(:reindex)
    ReindexGuidesJob.new.perform
  end
end
