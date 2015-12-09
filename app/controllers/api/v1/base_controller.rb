require 'openfarm_errors'

class Api::V1::BaseController < ActionController::Base
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  respond_to :json

  before_action :authenticate_from_token!
  before_action :verify_sent_data_structure

  serialization_scope :current_user

  rescue_from Mongoid::Errors::DocumentNotFound do |exc|
    json = { errors: [{ title: "Not Found. #{exc.message}" }] }
    render json: json, status: 404
  end

  rescue_from OpenfarmErrors::NotAuthorized do |exc|
    json = { errors: [{ title: "Not Authorized. #{exc.message}" }] }
    render json: json, status: 401
  end

  rescue_from Mongoid::Errors::Validations do |exc|
    json = { errors: [{ title: "Not valid. #{exc}"}]}
    render json: json, status: 403
  end

  # Convenience methods for serializing models:
  def serialize_model(model, options = {})
    options[:is_collection] = false
    options[:context] = { current_user: serialization_scope }
    JSONAPI::Serializer.serialize(model, options)
  end

  def serialize_models(models, options = {})
    options[:is_collection] = true
    options[:context] = { current_user: serialization_scope }
    JSONAPI::Serializer.serialize(models, options)
  end

  protected

  def verify_sent_data_structure
    # TODO verify that data structure
  end

  def authenticate_from_token!
    request.authorization.present? ? token_auth : authenticate_user!
  end

  def token_auth
    authenticate_or_request_with_http_token do |token, _options|
      user = Token::AuthorizationPolicy.new(token).build
      sign_in user, store: false if user
    end
  end

  def respond_with_mutation(status = :ok, options = {})
    if @outcome.success?
      result = @outcome.result
      if status == :no_content
        result = nil
      end
      render json: serialize_model(result, options), status: status
    else
      errors = @outcome.errors.message_list.map do |error|
        { 'title': error }
      end
      render json: { errors: errors },
             status: :unprocessable_entity
    end
  end
end
