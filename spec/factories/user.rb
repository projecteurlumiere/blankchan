FactoryBot.define do
  factory :user do
    passcode { SecureRandom.urlsafe_base64 }
    passcode_digest { User.digest(passcode) }
    role { 0 }
  end

  factory :moderator do
    user
  end

  factory :administrator do
    user
  end
end