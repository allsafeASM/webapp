class Subdomain < ApplicationRecord
  belongs_to :domain
  has_one :dns_record, dependent: :destroy
  has_many :webservers, dependent: :destroy

  # Many-to-many relationship with IPAddress through SubdomainIp
  has_many :subdomain_ips, dependent: :destroy
  has_many :ip_addresses, through: :subdomain_ips
end
