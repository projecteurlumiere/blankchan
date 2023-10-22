class User < ApplicationRecord
  attr_accessor :passcode, :remember_token

  enum role: {passcode_user: 0, moderator: 1, admin: 2}, _suffix: :role

  has_one :moderator
  has_one :administrator

  before_validation :digest_passcode, if: :passcode

  validate :passcode_is_unique

  def authenticate(passcode)
    user = find_user_by_passcode(passcode)
    false if user.nil? # that's how original has_secure_password authenticate method works
  end

  def remember_token_authenticated?(token)
    return false if remember_token_digest.empty? || token.nil?

    User.digest(token) == remember_token_digest
  end

  def remember
    self.remember_token = SecureRandom.urlsafe_base64
    update_column :remember_token_digest, User.digest(remember_token)
  end

  def remembered?(token)
    User.digest(token) == remember_token_digest
  end

  def self.digest(code)
    Digest::SHA256.hexdigest(code)
  end

  private

  def find_user_by_passcode(passcode)
    return nil if passcode.nil?

    User.find_by(passcode_digest: digest(passcode))
  end

  def digest_passcode
    self.passcode_digest = User.digest(passcode) # * self.passcode_digest is a setter, and passcode is a getter method aha!
  end

  def passcode_is_unique
    return true if passcode_digest.present?

    if User.find_by(passcode_digest: Digest::SHA256.hexdigest(passcode))
      errors.add :passcode, 'must be unique'
    end
  end
end



