module ApiTestHelper
  def generate_jwt_token(user)
    payload = { user_id: user.id }
    JWT.encode(payload, ENV["SECRET_KEY_BASE"])
  end

  def api_headers(user = nil)
    headers = { 'CONTENT_TYPE' => 'application/json' }
    headers['Authorization'] = "Bearer #{generate_jwt_token(user)}" if user
    headers
  end

  def authenticated_get(path, user, **options)
    get path, headers: api_headers(user), **options
  end

  def authenticated_post(path, user, **options)
    post path, headers: api_headers(user), **options
  end

  def authenticated_patch(path, user, **options)
    patch path, headers: api_headers(user), **options
  end

  def authenticated_put(path, user, **options)
    put path, headers: api_headers(user), **options
  end

  def authenticated_delete(path, user, **options)
    delete path, headers: api_headers(user), **options
  end
end

ActiveSupport.on_load(:action_dispatch_integration_test) do
  include ApiTestHelper
end
