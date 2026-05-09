class Api::Users::SessionsController < Api::BaseController
  skip_before_action :authenticate_user!, only: %i[create]

  def create
    authenticate_user = Users::AuthenticateUserService.call(user_params)

    if authenticate_user.success?
      render_resource(authenticate_user.payload, serializer: AuthenticatedUserSerializer, status: :ok)
    else
      render_errors(authenticate_user.errors, status: :unauthorized)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
