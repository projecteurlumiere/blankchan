FactoryBot.define do
  factory :user do
    passcode { SecureRandom.urlsafe_base64 }
    passcode_digest { User.digest(passcode) }
    role { 0 }

    factory :moderator do
      role { 1 }
    end

    factory :admin do
      role { 2 }
    end
  end
end