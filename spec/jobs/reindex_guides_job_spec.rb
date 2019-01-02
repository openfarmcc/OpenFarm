require 'spec_helper'

describe ReindexGuidesJob do
  it 'reindexes guides' do
    Guide.destroy_all
    FactoryBot.create(:guide)
    expect_any_instance_of(Guide).to receive(:reindex)
    ReindexGuidesJob.new.perform
  end
end
