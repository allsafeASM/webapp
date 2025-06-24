class Domain < ApplicationRecord
  belongs_to :user

  has_many :subdomains, dependent: :destroy
  has_many :vulnerability_scans, dependent: :destroy
  has_many :enumeration_scans, dependent: :destroy

  # A direct way to get all unique IPs for a domain
  has_many :ip_addresses, -> { distinct }, through: :subdomains

  validates :domain, presence: true, uniqueness: { scope: :user_id }, format: { with: /\A[a-zA-Z0-9.-]+\z/, message: "must be a valid domain name" }

  before_validation :normalize_domain

  private

  def normalize_domain
    self.domain = domain.strip.downcase if domain.present?
  end
end
