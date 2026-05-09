class Users::AuthenticateUserService < ApplicationService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    user = User.find_by(email: params[:email])

    if user&.valid_password?(params[:password])
      ServiceResponse.success(user)
    else
      ServiceResponse.failure("Invalid email or password")
    end
  end
end
