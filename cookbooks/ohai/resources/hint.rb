actions :create, :delete
default_action :create

attribute :hint_name, kind_of: String, name_attribute: true
attribute :content, kind_of: Hash, default: {}
