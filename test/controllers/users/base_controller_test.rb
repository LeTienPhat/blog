require "test_helper"

class Users::BaseControllerTest < ActionDispatch::IntegrationTest
  test "redirects unauthenticated users to sign in" do
    get users_posts_path

    assert_redirected_to new_user_session_path
  end

  test "allows authenticated users to access user routes" do
    user = User.create!(email: "user@example.com", password: "password", password_confirmation: "password")
    sign_in user

    get users_posts_path

    assert_response :success
  end

  test "user authentication is required for all user actions" do
    # Test that user routes require authentication
    get users_posts_path
    assert_redirected_to new_user_session_path

    get new_users_post_path
    assert_redirected_to new_user_session_path

    post users_posts_path, params: { post: { title: "Test" } }
    assert_redirected_to new_user_session_path
  end
end
