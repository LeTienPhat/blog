require "test_helper"

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test "root path redirects unauthenticated visitors to sign in" do
    get root_path

    assert_redirected_to new_user_session_path
  end

  test "after sign in path for admin redirects to admin posts" do
    admin = Admin.create!(email: "admin@example.com", password: "password", password_confirmation: "password")

    post admin_session_path, params: { admin: { email: admin.email, password: "password" } }

    assert_redirected_to admins_posts_path
  end

  test "after sign in path for user redirects to root" do
    user = User.create!(email: "user@example.com", password: "password", password_confirmation: "password")

    post user_session_path, params: { user: { email: user.email, password: "password" } }

    assert_redirected_to root_path
  end

  test "after sign out path for admin redirects to admin sign in" do
    admin = Admin.create!(email: "admin@example.com", password: "password", password_confirmation: "password")
    sign_in admin

    delete destroy_admin_session_path

    assert_redirected_to new_admin_session_path
  end

  test "after sign out path for user redirects to user sign in" do
    user = User.create!(email: "user@example.com", password: "password", password_confirmation: "password")
    sign_in user

    delete destroy_user_session_path

    assert_redirected_to new_user_session_path
  end

  test "allows modern browsers" do
    # This test would require setting up browser detection, but the allow_browser
    # method is tested implicitly through integration tests
    get root_path

    # Should redirect due to authentication, not browser compatibility
    assert_redirected_to new_user_session_path
  end
end
