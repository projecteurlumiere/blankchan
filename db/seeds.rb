# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# clear storage:

sh "cd ..; rm -rf #{Rails.root}/storage"

n_boards = 10
n_topics = 30
n_posts = 10
n_pics = 1..3

# Boards:

boards = []

n_boards.times do
  board_name = Faker::NatoPhoneticAlphabet.code_word while boards.any? {|b| b.name == board_name}
  boards << Board.new(name: board_name)
end

boards.each { |b| puts b.name }

Board.import boards

# Topics:

all_topics = Board.all.each_with_object([]) do |board, all_topics|
  topics = []

  n_topics.times do
    topics << Topic.new(board_id: board.id)
  end

  all_topics << topics
end.flatten

Topic.import all_topics

# Posts

all_posts = Topic.all.each_with_object([]) do |topic, all_posts|
  posts = []
  n_posts.times do
    post = Post.new(topic_id: topic.id, name: Faker::ChuckNorris.fact, text: Faker::Lorem.paragraph(sentence_count: 15))
    posts << post
  end
  all_posts << posts
end.flatten

Post.import all_posts

# Files (first board only)

puts "starting processing images"

posts_for_images = Board.all.order(name: :asc).limit(1).each_with_object([]) do |board, posts_for_images|
  board.topics.each_with_object(posts_for_images) do |topic, posts_for_images|
    topic.posts.each { |post| posts_for_images << post }
  end
end

total = posts_for_images.count

posts_for_images.each_with_index do |post, i|
  puts "processing post #{post.id}. #{i} out of #{total}"
  files = []
  rand(1..3).times do
    files << {io: FFaker::Image.file(size: "1000x1000"),
              filename: "#{Faker::Alphanumeric.alpha(number: 15)}.png"}
  end
  post.images.attach(files)
end

puts "done with images"

puts "starting processing thumbs"

posts = Post.all
posts_count = posts.count

posts.each_with_index do |post, i|
  return if post.images.nil?

  puts "processing #{i} out of #{posts_count}"
  post.images.each do |image|
    begin
      post.image_as_thumb(image)
    rescue SQLite3::BusyException, ActiveRecord::StatementInvalid
      puts "Database got locked!"
      sleep 1
      post.image_as_thumb(image)
    ensure
      next
    end
  end
end

puts "thumbs have been processed"

# Users

puts "creating users"

passcodes = []

3.times do
  passcode = SecureRandom.urlsafe_base64
  user = User.create(passcode: passcode)
  passcodes << "#{user.id} - #{passcode}"
end

1.times do
  first_user_id = passcodes[0].split(' - ')[0].to_i
  User.find(first_user_id).create_administrator
end

1.times do
  second_user_id = passcodes[1].split(' - ')[0].to_i
  moderator = User.find(second_user_id).create_moderator
  moderator.supervised_board = Board.first.name
  moderator.save
end

File.write("./db/passcode.txt", "first is always admin\'s code, \nsecond is moderator\'s" + passcodes.join("\n"))

puts "done with users"

puts "done"
