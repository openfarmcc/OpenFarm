class ApplicationSerializer < ActiveModel::Serializer
  def current_user
    scope
  end
end
