class SubdomainIp < ApplicationRecord
  belongs_to :subdomain
  belongs_to :ip_address
end
