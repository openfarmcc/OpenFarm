actions :set
default_action :set

attribute :key,   kind_of: String, name_attribute: true
attribute :value, kind_of: String, required: true
attribute :scope, equal_to: %w(local global system), default: 'global'
attribute :path,  kind_of: String
attribute :user,  kind_of: String
attribute :options, kind_of: String

attr_accessor :exists
