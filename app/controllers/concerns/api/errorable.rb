module Api::Errorable
  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::ParameterMissing do |e|
      render json: { status: '400', title: "Bad Request", error: e.message }, status: :bad_request
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { status: '404', title: "Not Found", error: e.message }, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: { status: '422', title: "Unprocessable Entity", errors: e.record.errors.full_messages }, status: :unprocessable_entity
    end

    rescue_from StandardError do |e|
      render json: { status: '500', title: "Internal Server Error", error: e.message }, status: :internal_server_error
    end
  end
end
