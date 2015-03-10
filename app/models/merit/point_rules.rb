# Points are a simple integer value which are given to "meritable" resources
# according to rules in +app/models/merit/point_rules.rb+. They are given on
# actions-triggered.

module Merit
  class PointRules
    include Merit::PointRulesMethods

    def initialize
      # empty, who knows if we'll implement points, but we need the
      # thing for merit to work.
    end
  end
end
