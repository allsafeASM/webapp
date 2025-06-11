class User < ApplicationRecord
  has_secure_password validations: -> { password_digest.nil? }
  has_many :sessions, dependent: :destroy
  has_many :identities, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
  validates :password, length: { minimum: 8 }, if: -> { password.present? }
  
  def self.from_omniauth(auth_hash)
    email = auth_hash.info.email&.downcase
    user = find_by(email_address: email)
    
    # Create new user if not exists
    if user.nil? && email.present?
      user = create(
        email_address: email,
        password: SecureRandom.hex(16) # Random password since they'll login via OAuth
      )
    end
    
    # Create/update identity if user was found or created
    if user.present?
      Identity.find_or_create_from_auth_hash(user, auth_hash)
    end
    
    user
  end
end
