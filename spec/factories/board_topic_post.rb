FactoryBot.define do
  factory :board do
    # may sometimes raise error about the name duplication
    name { "#{Faker::NatoPhoneticAlphabet.code_word}-#{rand(1..1000)}".downcase }
    full_name { name.capitalize }

    after :create do |board|
      create_list :topic, 3, board: board
    end
  end

  factory :topic do
    board

    after :create do |topic|
      create_list :post, 3, topic: topic
    end
  end

  factory :post do
    name { Faker::ChuckNorris.fact[0..99] }
    text { Faker::Lorem.paragraph(sentence_count: 15) }

    topic
  end
end