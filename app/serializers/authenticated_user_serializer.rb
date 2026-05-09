class AuthenticatedUserSerializer < ApplicationSerializer
  attributes :id, :email, :auth_token
end
