module Guides
  # Place shared functionality between Guide mutations here to stay DRY.
  module GuidesConcern

    def validate_time_span
    end

    def set_time_span
      if attributes[:time_span]
        @guide.time_span = TimeSpan.new(attributes[:time_span])
      end
    end
  end
end
