class User < ApplicationRecord
  has_secure_password validations: -> { password_digest.nil? }
  has_many :sessions, dependent: :destroy
  has_many :identities, dependent: :destroy
  has_many :domains, dependent: :destroy
  has_many :vulnerability_scans, dependent: :destroy
  has_many :enumeration_scans, dependent: :destroy

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
        password: SecureRandom.hex(16), # Random password since they'll login via OAuth
        verified_at: Time.current # Automatically verify on creation
      )
    end

    # Create/update identity if user was found or created
    if user.present?
      Identity.find_or_create_from_auth_hash(user, auth_hash)
    end

    user
  end

  def verified?
    verified_at.present?
  end

  def generate_email_verification_token
    verifier = ActiveSupport::MessageVerifier.new(Rails.application.secret_key_base, digest: "SHA256")
    verifier.generate({ user_id: id, sent_at: Time.current.to_i })
  end

  def self.find_by_email_verification_token!(token)
    verifier = ActiveSupport::MessageVerifier.new(Rails.application.secret_key_base, digest: "SHA256")
    data = verifier.verify(token)
    # Rails.logger.info "Decoded verification token: #{data.inspect}"
    user = find(data["user_id"])
    # Rails.logger.info "Found user: #{user.inspect}"
    raise ActiveRecord::RecordNotFound unless user && !user.verified?
    user
  rescue ActiveSupport::MessageVerifier::InvalidSignature, ActiveRecord::RecordNotFound
    raise ActiveRecord::RecordNotFound
  end
end
