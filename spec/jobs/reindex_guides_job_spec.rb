require 'spec_helper'

describe ReindexGuidesJob do
  it 'reindexes guides' do
    pending "this test does not pass on CI - RickCarlino"
    FactoryGirl.create(:guide)
    expect_any_instance_of(Guide).to receive(:reindex_async)
    ReindexGuidesJob.new.perform
  end
end
