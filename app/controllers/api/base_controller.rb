class Api::BaseController < ActionController::API
  include Api::Renderable
  include Api::Errorable

  before_action :authenticate_user!

  attr_reader :current_user

  private

  def authenticate_user!
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last if auth_header

    if token
      begin
        decoded_token = JWT.decode(token, ENV["SECRET_KEY_BASE"])[0]
        @current_user = User.find(decoded_token['user_id'])
      rescue JWT::DecodeError
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    else
      render json: { error: 'Missing token' }, status: :unauthorized
    end
  end
end
