class Domain < ApplicationRecord
  belongs_to :user

  has_many :subdomains, dependent: :destroy
  has_many :vulnerability_scans, dependent: :destroy
  has_many :enumeration_scans, dependent: :destroy

  # A direct way to get all unique IPs for a domain
  has_many :ip_addresses, -> { distinct }, through: :subdomains

end
