require "test_helper"

class Admins::CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = Admin.create!(email: "admin.comments@example.com", password: "password", password_confirmation: "password")
    sign_in @admin
    @post = Post.create!(title: "Admin Commentable", authorable: @admin)
  end

  test "creates a comment and redirects to the admin post page" do
    assert_difference("@post.comments.count", 1) do
      post admins_post_comments_path(@post), params: { comment: { content: "Admin feedback" } }
    end

    assert_redirected_to admins_post_path(@post)
  end

  test "creates comment with valid content" do
    assert_difference("Comment.count", 1) do
      post admins_post_comments_path(@post), params: { comment: { content: "Valid comment content" } }
    end

    comment = Comment.last
    assert_equal "Valid comment content", comment.content
    assert_equal @post, comment.post
  end

  test "creates multiple comments on the same post" do
    assert_difference("@post.comments.count", 2) do
      post admins_post_comments_path(@post), params: { comment: { content: "First comment" } }
      post admins_post_comments_path(@post), params: { comment: { content: "Second comment" } }
    end
  end

  test "comment creation sets timestamps correctly" do
    freeze_time do
      post admins_post_comments_path(@post), params: { comment: { content: "Timestamp test" } }

      comment = Comment.last
      assert_equal Time.current, comment.created_at
      assert_equal Time.current, comment.updated_at
    end
  end

  test "redirects to correct admin post path after comment creation" do
    post admins_post_comments_path(@post), params: { comment: { content: "Redirect test" } }

    assert_redirected_to admins_post_path(@post)
  end

  test "handles non-existent post gracefully" do
    assert_no_difference("Comment.count") do
      post admins_post_comments_path(99999), params: { comment: { content: "Test" } }
    end
  end
end
