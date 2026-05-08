module Schedulers
  class TriggerCreateComment
    include Sidekiq::Worker

    def perform
      Comment.create!(
        content: "This is a scheduled comment created at #{Time.current}",
        post_id: Post.order("RANDOM()").first.id
      ) if Post.exists?
    end
  end
end
