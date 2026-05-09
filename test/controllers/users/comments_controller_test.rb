require "test_helper"

class Users::CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "user.comments@example.com", password: "password", password_confirmation: "password")
    sign_in @user
    @post = Post.create!(title: "Commentable Post", authorable: @user)
  end

  test "creates a new comment and redirects to the post show page" do
    assert_difference("@post.comments.count", 1) do
      post users_post_comments_path(@post), params: { comment: { content: "Great post" } }
    end

    assert_redirected_to users_post_path(@post)
  end

  test "creates comment with valid content" do
    assert_difference("Comment.count", 1) do
      post users_post_comments_path(@post), params: { comment: { content: "Valid user comment content" } }
    end

    comment = Comment.last
    assert_equal "Valid user comment content", comment.content
    assert_equal @post, comment.post
  end

  test "creates multiple comments on the same post" do
    assert_difference("@post.comments.count", 2) do
      post users_post_comments_path(@post), params: { comment: { content: "First user comment" } }
      post users_post_comments_path(@post), params: { comment: { content: "Second user comment" } }
    end
  end

  test "comment creation sets timestamps correctly" do
    freeze_time do
      post users_post_comments_path(@post), params: { comment: { content: "User timestamp test" } }

      comment = Comment.last
      assert_equal Time.current, comment.created_at
      assert_equal Time.current, comment.updated_at
    end
  end

  test "redirects to correct user post path after comment creation" do
    post users_post_comments_path(@post), params: { comment: { content: "User redirect test" } }

    assert_redirected_to users_post_path(@post)
  end

  test "handles non-existent post gracefully" do
    assert_no_difference("Comment.count") do
      post users_post_comments_path(99999), params: { comment: { content: "Test" } }
    end
  end
end
