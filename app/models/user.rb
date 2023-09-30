class User < ApplicationRecord
  attr_accessor :passcode, :remember_token

  has_one :moderator

  before_validation :digest_passcode, if: :passcode

  validate :passcode_is_unique

  def remember
    self.remember_token = SecureRandom.urlsafe_base64
    update_column :remember_token_digest, digest(remember_token)
  end

  def remembered?(token)
    digest(token) == remember_token_digest
  end

  private

  def digest(code)
    Digest::SHA256.hexdigest(code)
  end

  def digest_passcode
    self.passcode_digest = digest(passcode) # * self.passcode_digest is a setter, and passcode is a getter method aha!
  end

  def passcode_is_unique
    if User.find_by(passcode_digest: Digest::SHA256.hexdigest(passcode))
      errors.add :passcode, 'must be unique'
    end
  end
end



