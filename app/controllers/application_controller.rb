class ApplicationController < ActionController::API
  def unauthorized_entity(entity_name)
    render json: ['Unauthorized'], status: :unauthorized
  end

  def forbidden
    render json: ['Forbidden'], status: :forbidden
  end

  def bad_request
    render json: ['Bad request'], status: :bad_request
  end

  def not_modified
    render json: ['Not modified'], status: :not_modified
  end

  def not_found
    render json: ['Not found'], status: :not_found
  end

  def bad_request
    render json: ['Bad request'], status: :bad_request
  end
end
