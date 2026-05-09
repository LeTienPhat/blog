# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

admin = Admin.create!(email: "admin@example.com", password: "password")
user = User.create!(email: "user@example.com", display_name: "Regular User", password: "password")

# create posts for admin
10.times do |i|
  Post.create!(
    title: "Admin Post #{i + 1}",
    body: "This is the body of admin post #{i + 1}.",
    authorable: admin
  )
end

# create posts for user
10.times do |i|
  Post.create!(
    title: "User Post #{i + 1}",
    body: "This is the body of user post #{i + 1}.",
    authorable: user
  )
end
