module Api::Renderable
  extend ActiveSupport::Concern

  def render_resource(resource, serializer: nil, status: :ok)
    render json: serializer ? serializer.new(resource).serializable_hash.to_json : resource, status: status
  end

  def render_errors(errors, options = {})
    render json: { errors: errors }, status: options[:status] || :unprocessable_entity
  end
end
