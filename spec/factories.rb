FactoryBot.define do
  factory :board do
    name Faker::NatoPhoneticAlphabet.code_word
  end
end