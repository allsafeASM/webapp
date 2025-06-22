class IpAddress < ApplicationRecord
  has_many :open_ports, dependent: :destroy

  # Many-to-many relationship with Subdomain through SubdomainIp
  has_many :subdomain_ips, dependent: :destroy
  has_many :subdomains, through: :subdomain_ips
end
