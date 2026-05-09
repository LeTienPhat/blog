class Api::MeController < Api::BaseController
  before_action :authenticate_user!

  def show
    render json: current_user, serializer: UserSerializer
  end
end
