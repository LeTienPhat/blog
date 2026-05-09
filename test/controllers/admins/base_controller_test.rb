require "test_helper"

class Admins::BaseControllerTest < ActionDispatch::IntegrationTest
  test "redirects unauthenticated admins to sign in" do
    get admins_posts_path

    assert_redirected_to new_admin_session_path
  end

  test "allows authenticated admins to access admin routes" do
    admin = Admin.create!(email: "admin@example.com", password: "password", password_confirmation: "password")
    sign_in admin

    get admins_posts_path

    assert_response :success
  end

  test "admin authentication is required for all admin actions" do
    # Test that admin routes require authentication
    get admins_posts_path
    assert_redirected_to new_admin_session_path

    get new_admins_post_path
    assert_redirected_to new_admin_session_path

    post admins_posts_path, params: { post: { title: "Test" } }
    assert_redirected_to new_admin_session_path
  end
end
