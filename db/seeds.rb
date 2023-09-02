# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

10.times do
  Board.create(name: Faker::NatoPhoneticAlphabet.code_word)
end

Board.all.each do |board|
  5.times do 
    new_topic = Topic.new(board_id: board.id)
    new_topic.save
    10.times do
      Post.create(topic_id: new_topic.id, name: Faker::ChuckNorris.fact, text: Faker::Lorem.paragraph(sentence_count: 15))
    end
  end
end