# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(email: "user@test.com", password: "password", password_confirmation: "password")
  end

  test "user should have valid attributes" do
    assert @user.valid?
  end

  test "email is required" do
    @user.email = nil
    assert_not @user.valid?
    assert_includes @user.errors[:email], "can't be blank"
  end

  test "email must be unique" do
    duplicate_user = User.new(email: @user.email, password: "password123", password_confirmation: "password123")
    assert_not duplicate_user.valid?
  end

  test "password is required" do
    user = User.new(email: "test@test.com")
    user.password = nil
    user.password_confirmation = nil
    assert_not user.valid?
  end

  test "password must be at least 6 characters" do
    @user.password = "pass"
    @user.password_confirmation = "pass"
    assert_not @user.valid?
  end

  test "user can create posts" do
    assert_difference "Post.count" do
      @user.posts.create!(title: "Test Post")
    end
  end

  test "posts are destroyed when user is destroyed" do
    @user.posts.create!(title: "Test Post 1")
    @user.posts.create!(title: "Test Post 2")
    assert_equal 2, @user.posts.count

    user_id = @user.id
    @user.destroy

    assert_equal 0, Post.where(authorable_type: "User", authorable_id: user_id).count
  end

  test "user should have many posts" do
    assert_respond_to @user, :posts
  end
end
