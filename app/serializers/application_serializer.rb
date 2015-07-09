# OUT OF DATE. 08/07/2015
class ApplicationSerializer < ActiveModel::Serializer
  def current_user
    scope
  end
end
