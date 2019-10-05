module Guides
  # Place shared functionality between Guide mutations here to stay DRY.
  module GuidesConcern
    def validate_time_span; end

    def set_time_span
      @guide.time_span = TimeSpan.new(attributes[:time_span]) if attributes[:time_span]
    end

    def validate_practices
      if attributes[:practices]
        attributes[:practices].each do |p|
          unless p.is_a? String
            msg = "#{p} is not a valid practice."
            add_error :practices, :invalid, msg
          end
        end
      end
    end
  end
end
