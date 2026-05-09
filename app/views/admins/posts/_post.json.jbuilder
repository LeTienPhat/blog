json.extract! post, :id, :title, :body, :created_at, :updated_at
json.url admins_post_url(post, format: :json)
