require 'spec_helper'

describe ReindexGuidesJob do
  it 'reindexes guides' do
    expect(Guide).to receive(:reindex)

    ReindexGuidesJob.new.perform
  end
end
