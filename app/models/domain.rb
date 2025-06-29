class Domain < ApplicationRecord
  belongs_to :user

  has_many :subdomains, dependent: :destroy
  has_many :vulnerability_scans, dependent: :destroy
  has_many :enumeration_scans, dependent: :destroy

  # A direct way to get all unique IPs for a domain
  has_many :ip_addresses, -> { distinct }, through: :subdomains

  validates :domain, presence: true, uniqueness: { scope: :user_id }, format: { with: /\A(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,63}\z/, message: "must be a valid domain name" }

  before_validation :normalize_domain

  broadcasts_to ->(domain) { [ domain.user, :domains ] }, inserts_by: :prepend, target: "domains"

  after_create_commit do
    if user.domains.one? # First domain for the user
      broadcast_remove_to [ user, :domains ], target: "no_domains_message"
    end
  end

  after_destroy_commit do
    if user.domains.empty? # Last domain for the user
      broadcast_append_to [ user, :domains ], target: "domains", partial: "domains/no_domains_message"
    end
  end

  private

  def normalize_domain
    self.domain = domain.strip.downcase if domain.present?
  end
end
