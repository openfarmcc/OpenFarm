# frozen_string_literal: true

# Some monkey patches to string that we needed.
class String
  # Tells you if a string is actually a fully formed URL
  def valid_url?
    URI.parse(self).is_a?(URI::HTTP)
  rescue URI::InvalidURIError
    false
  end
end
