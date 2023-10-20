desc "populates Posts for_preview column"

task populate_preview_posts: :environment do
  @topics = Topic.includes(:posts).all
  total = @topics.count
  @topics.each_with_index do |topic, i|
    puts "processing #{i + 1} out of #{total}"
    posts = topic.posts
    posts.first.update(for_preview: true)

    count = posts.count
    case count
    when 1
      next
    when 2..3
      last_posts = topic.posts.last(count - 1)
    else
      last_posts = topic.posts.last(3)
    end

    last_posts.each do |posts|
      posts.update(for_preview: true)
    end
  end
end