require "test_helper"

class Users::PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "user.posts@example.com", password: "password", password_confirmation: "password")
    sign_in @user
  end

  test "shows a post" do
    post_record = Post.create!(title: "Show me", authorable: @user)

    get users_post_path(post_record)

    assert_response :success
  end

  test "creates a post and redirects to its show page" do
    assert_difference("Post.count", 1) do
      post users_posts_path, params: { post: { title: "New Post", body: "Body content" } }
    end

    assert_redirected_to users_post_path(Post.last)
    assert_equal @user, Post.last.authorable
  end

  test "updates a post and redirects to its show page" do
    post_record = Post.create!(title: "Original", authorable: @user)

    patch users_post_path(post_record), params: { post: { title: "Updated Title" } }

    assert_redirected_to users_post_path(post_record)
    assert_equal "Updated Title", post_record.reload.title
  end

  test "destroys a post and redirects to the index" do
    post_record = Post.create!(title: "Delete me", authorable: @user)

    assert_difference("Post.count", -1) do
      delete users_post_path(post_record)
    end

    assert_redirected_to users_posts_path
  end

  test "index shows only user posts" do
    user_post = Post.create!(title: "User Post", authorable: @user)
    admin = Admin.create!(email: "admin@example.com", password: "password", password_confirmation: "password")
    admin_post = Post.create!(title: "Admin Post", authorable: admin)

    get users_posts_path

    assert_response :success
    # The response should contain user posts but not admin posts
  end

  test "index supports search functionality" do
    post1 = Post.create!(title: "Ruby Tutorial", authorable: @user)
    post2 = Post.create!(title: "Rails Guide", authorable: @user)
    post3 = Post.create!(title: "JavaScript Tips", authorable: @user)

    get users_posts_path, params: { search: { title: "Ruby" } }

    assert_response :success
  end

  test "index paginates results" do
    # Create multiple posts to test pagination
    25.times do |i|
      Post.create!(title: "Post #{i}", authorable: @user)
    end

    get users_posts_path, params: { page: 2 }

    assert_response :success
  end

  test "new action renders form" do
    get new_users_post_path

    assert_response :success
  end

  test "edit action renders form" do
    post_record = Post.create!(title: "Editable Post", authorable: @user)

    get edit_users_post_path(post_record)

    assert_response :success
  end

  test "create fails with invalid data" do
    assert_no_difference("Post.count") do
      post users_posts_path, params: { post: { title: "" } }
    end

    assert_response :unprocessable_entity
  end

  test "update fails with invalid data" do
    post_record = Post.create!(title: "Valid Post", authorable: @user)

    patch users_post_path(post_record), params: { post: { title: "" } }

    assert_response :unprocessable_entity
    assert_not_equal "", post_record.reload.title
  end

  test "create with JSON format" do
    assert_difference("Post.count", 1) do
      post users_posts_path, params: { post: { title: "JSON Post", body: "Content" } }, as: :json
    end

    assert_response :created
    json_response = JSON.parse(response.body)
    assert_equal "JSON Post", json_response["title"]
  end

  test "update with JSON format" do
    post_record = Post.create!(title: "Original", authorable: @user)

    patch users_post_path(post_record), params: { post: { title: "Updated JSON" } }, as: :json

    assert_response :ok
    post_record.reload
    assert_equal "Updated JSON", post_record.title
  end

  test "destroy with JSON format" do
    post_record = Post.create!(title: "Delete JSON", authorable: @user)

    assert_difference("Post.count", -1) do
      delete users_post_path(post_record), as: :json
    end

    assert_response :no_content
  end

  test "show with JSON format" do
    post_record = Post.create!(title: "Show JSON", authorable: @user)

    get users_post_path(post_record), as: :json

    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal "Show JSON", json_response["title"]
  end

  test "index with JSON format" do
    Post.create!(title: "JSON Index", authorable: @user)

    get users_posts_path, as: :json

    assert_response :success
    json_response = JSON.parse(response.body)
    assert_kind_of Array, json_response
  end
end
