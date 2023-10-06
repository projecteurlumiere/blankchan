# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

10.times do
  board_name = Faker::NatoPhoneticAlphabet.code_word
  board_name = Faker::NatoPhoneticAlphabet.code_word while Board.find_by(name: board_name)
  Board.create(name: board_name)
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

File.write("./db/passcode.txt", "first is always admin's code\n, second is moderator's" + passcodes.join("\n"))