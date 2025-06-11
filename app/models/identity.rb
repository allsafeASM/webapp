class Identity < ApplicationRecord
  belongs_to :user
  
  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }
  
  def self.find_or_create_from_auth_hash(user, auth_hash)
    identity = find_or_initialize_by(provider: auth_hash.provider, uid: auth_hash.uid)
    
    # Convert expires_at from integer timestamp to DateTime if present
    expires_at_value = auth_hash.credentials.expires_at.present? ? 
      Time.at(auth_hash.credentials.expires_at) : 
      nil
    
    identity.update(
      user: user,
      name: auth_hash.info.name,
      email: auth_hash.info.email,
      image: auth_hash.info.image,
      token: auth_hash.credentials.token,
      refresh_token: auth_hash.credentials.refresh_token,
      expires_at: expires_at_value
    )
    
    identity
  end
end
