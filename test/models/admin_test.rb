# == Schema Information
#
# Table name: admins
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
#  index_admins_on_email                 (email) UNIQUE
#  index_admins_on_reset_password_token  (reset_password_token) UNIQUE
#
require "test_helper"

class AdminTest < ActiveSupport::TestCase
  setup do
    @admin = Admin.create!(email: "admin@test.com", password: "password", password_confirmation: "password")
  end

  test "admin should have valid attributes" do
    assert @admin.valid?
  end

  test "email is required" do
    @admin.email = nil
    assert_not @admin.valid?
    assert_includes @admin.errors[:email], "can't be blank"
  end

  test "email must be unique" do
    duplicate_admin = Admin.new(email: @admin.email, password: "password123", password_confirmation: "password123")
    assert_not duplicate_admin.valid?
  end

  test "password is required" do
    admin = Admin.new(email: "test@test.com")
    admin.password = nil
    admin.password_confirmation = nil
    assert_not admin.valid?
  end

  test "admin can create posts" do
    assert_difference "Post.count" do
      @admin.posts.create!(title: "Test Post")
    end
  end

  test "posts are destroyed when admin is destroyed" do
    @admin.posts.create!(title: "Test Post 1")
    @admin.posts.create!(title: "Test Post 2")
    assert_equal 2, @admin.posts.count

    admin_id = @admin.id
    @admin.destroy

    assert_equal 0, Post.where(authorable_type: "Admin", authorable_id: admin_id).count
  end

  test "admin should have many posts" do
    assert_respond_to @admin, :posts
  end
end
