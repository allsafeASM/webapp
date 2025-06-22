class Webserver < ApplicationRecord
  belongs_to :subdomain

  # Many-to-many relationship with Technology through WebserversTechnology
  has_many :webservers_technologies, dependent: :destroy
  has_many :technologies, through: :webservers_technologies
end
