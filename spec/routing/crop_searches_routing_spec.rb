require 'spec_helper'

describe CropSearchesController do
  describe 'routing' do

    it 'routes to #search' do
      expect(get: '/crop_search').to route_to('crop_searches#search')
    end

    it 'routes to #search' do
      expect(post: '/crop_search').to route_to('crop_searches#search')
    end

  end
end
