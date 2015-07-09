# Using https://github.com/fotinakis/jsonapi-serializers
require 'jsonapi-serializers'

class BaseSerializer < ActiveModel::Serializer
  include JSONAPI::Serializer

  def self_link
    "/api/v1#{super}"
  end

  def relationship_self_link(attribute_name)
    nil
  end

  def format_name(attribute_name)
    # We're overriding the standard name format because both
    # JavaScript and Ruby work better with an `_` than a `-` in names.
    # This is counter to the [JSON-API recommendation on naming](http://jsonapi.org/recommendations/#naming).
    attribute_name.to_s
  end

  def unformat_name(attribute_name)
    attribute_name.to_s
  end

  def current_user
    context[:current_user]
  end
end
