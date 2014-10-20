module OpenfarmErrors
  class NotAuthorized < StandardError; end
  class StaleToken < StandardError; end
end
