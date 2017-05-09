# frozen_string_literal: true
module Icons
  class Create < Mutations::Command
    required do
      model :user
      hash :attributes do
        optional do
          # Optional, but very useful for icon search.
          string :description
        end

        required do
          string :name
          string :svg, max_length: 50.kilobytes
        end
      end
    end

    def execute
      Icon.create!(inputs[:attributes].merge(user: user))
    end
  end
end
